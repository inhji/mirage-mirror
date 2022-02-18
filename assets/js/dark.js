export default function darkMode() {
	const darkModeToggle = document.querySelector(".theme-toggle")

	darkModeToggle.addEventListener('click' ,function (e) {
		e.preventDefault()

		if (document.documentElement.dataset.theme === "day") {
			//document.body.classList.remove("dark")
			document.documentElement.dataset.theme = "night"
			localStorage.theme = 'night'
			console.log("Night Theme loaded!")
		} else {
			// document.body.classList.add("dark")
			document.documentElement.dataset.theme = "day"
			localStorage.theme = 'day'
			console.log("Day Theme loaded!")
		}
	})
}