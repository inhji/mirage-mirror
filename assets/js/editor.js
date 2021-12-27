import {keymap} from "prosemirror-keymap"
import {EditorView} from "prosemirror-view"
import {Schema, DOMParser} from "prosemirror-model"
import {EditorState, Plugin} from "prosemirror-state"
import {undo, redo, history} from "prosemirror-history"
import {baseKeymap, toggleMark} from "prosemirror-commands"
import {schema, defaultMarkdownParser,
        defaultMarkdownSerializer} from "prosemirror-markdown"

const render = function(callback) {
	return new Plugin({
		view: view => ({
			update(updatedView, prevState) {
				const markdown = defaultMarkdownSerializer.serialize(updatedView.state.doc)
				callback(markdown)
			}
		})
	})
}

const mySchema = new Schema({
	nodes: schema.spec.nodes,
	marks: schema.spec.marks
})

const keys = {
	...baseKeymap,
	"Mod-z": undo, 
	"Mod-y": redo,
	"Ctrl-b": toggleMark(mySchema.marks.strong),
	"Ctrl-i": toggleMark(mySchema.marks.em),
	"Ctrl-Shift-i": toggleMark(mySchema.marks.code)
}

class MarkdownView {
  constructor(target, contentElement) {
    this.textarea = target.appendChild(document.createElement("textarea"))
    this.textarea.value = contentElement.value
    this.textarea.rows = 20
  }

  get content() { return this.textarea.value }
  focus() { this.textarea.focus() }
  destroy() { this.textarea.remove() }
}

class ProseMirrorView {
  constructor(target, contentElement) {
    this.view = new EditorView(target, {
      state: EditorState.create({
  	    doc: defaultMarkdownParser.parse(contentElement.value),
  	    schema: mySchema,
  	    plugins: [
          history(),
          keymap(keys),
  	 			render(markdown => contentElement.value = markdown),
        ]
  	  })
    })
  }

  get content() {
    return defaultMarkdownSerializer.serialize(this.view.state.doc)
  }
  focus() { this.view.focus() }
  destroy() { this.view.destroy() }
}

const createEditor = function (contentElement) {
	let place = document.querySelector("#editor")
	let view = new ProseMirrorView(place, contentElement)

	document.querySelectorAll("input[type=radio]").forEach(button => {
	  button.addEventListener("change", () => {
	    if (!button.checked) {
	    	return
	    }
	    let View = button.value == "markdown" ? MarkdownView : ProseMirrorView


	    if (view instanceof View) {
	    	return
	    }

	    let content = view.content

	    view.destroy()
	    contentElement.value = content
	    view = new View(place, contentElement)
	    view.focus()
	  })
	})
}


export default createEditor