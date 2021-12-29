module.exports = {
  mode: 'jit',
  // https://tailwindcss.com/docs/configuration#important
  important: '#app',
  content: [
    './js/**/*.js',
    '../lib/*_web/**/*.*ex'
  ],
  theme: {
    extend: {
      colors: {
        base: '#EDEAEA',
        low: '#DDDDDD',
        med: '#808790',
        high: '#393B3F',
        accent1: '#ff78a9',
        accent2: '#00aefe'
      }
    }
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography')
  ],
}