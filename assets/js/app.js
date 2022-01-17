// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
// import "../css/app.css"

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "./vendor/some-package.js"
//
// Alternatively, you can `npm install some-package` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
import "alpinejs"
import "./livesocket"
import darkMode from "./dark"

// Establish Phoenix Socket and LiveView configuration.
import createEditor from "./editor"

document.addEventListener("DOMContentLoaded", function () {
	// Initialize prosemirror for all editorElements
	// A #editor div as container is required 
	const editorElements = ["#note_content", "#list_content", "#bookmark_content"]
	editorElements.forEach(async el => {
		const $el = document.querySelector(el)
		if ($el && document.querySelector("#editor")) {
			createEditor($el)
		}
	})

	darkMode()
	
})

