import { Editor, rootCtx, themeFactory, defaultValueCtx } from '@milkdown/core';
import { nord } from '@milkdown/theme-nord';
import { commonmark } from '@milkdown/preset-commonmark';
import { injectGlobal, css } from "@emotion/css";
import { listener, listenerCtx } from '@milkdown/plugin-listener';

const theme = themeFactory({
	font: {
		typography: ['Inter', 'Helvetica', 'Arial'],
		code: ['Fira Code']
	}
})


const createEditor = async function (contentElement) {
	const editor = Editor.make()
		.config(function (ctx) {
			ctx.set(rootCtx, document.querySelector("#editor"))
			ctx.set(defaultValueCtx, contentElement.value)
			ctx.set(listenerCtx, {
		    markdown: [
		      (getMarkdown) => {
		        markdown = getMarkdown()
		        contentElement.value = markdown
		      }
		    ],
			})
		})
		.use(theme)
		.use(commonmark)
		.use(listener)
		.create()

	console.log("Editor created!")
	console.log(editor)
}

export default createEditor