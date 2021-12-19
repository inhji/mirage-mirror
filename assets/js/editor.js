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

const createEditor = function (contentElement) {
	new EditorView(document.querySelector("#editor"), {
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


export default createEditor