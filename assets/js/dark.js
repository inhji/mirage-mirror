export default function darkMode() {
	const darkModeToggle = document.querySelector(".dark-mode-toggle")
	darkModeToggle.addEventListener('click' ,function (e) {
		e.preventDefault()

		if (document.body.classList.contains("dark")) {
			document.body.classList.remove("dark")
			localStorage.theme = 'light'
		} else {
			document.body.classList.add("dark")
			localStorage.theme = 'dark'
		}
	})
}