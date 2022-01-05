const colors = require('tailwindcss/colors')

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
      colors: ({ theme }) => ({
        accent1: colors.pink['500'],
        accent2: colors.sky['500']
      })
    }
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography')
  ],
}