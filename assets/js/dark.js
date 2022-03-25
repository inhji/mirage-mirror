export default function darkMode() {
	const darkModeToggles = document.querySelectorAll(".theme-toggle")
	console.log(darkModeToggles)

	darkModeToggles.forEach(toggle => {
		console.log("Toggle")
		toggle.addEventListener('click', e => {
			e.preventDefault()

			const theme = toggle.dataset.theme
			document.documentElement.dataset.theme = theme
			localStorage.theme = theme
			console.log(`Theme '${theme}' loaded!`)
		})
	})
}