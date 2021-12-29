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
      },
      // textColor: {
      //   high: '#393B3F',
      //   med: '#808790',
      //   low: '#A3A3A4',
      //   inv: '#ffffff'
      // },
      // textDecorationColor: {
      //   high: '#393B3F',
      //   med: '#808790',
      //   low: '#A3A3A4',
      //   inv: '#ffffff'
      // },
      // borderColor: {
      //   high: '#393B3F',
      //   med: '#808790',
      //   low: '#A3A3A4',
      //   inv: '#ffffff'
      // },
      // backgroundColor: {
      //   high: '#333333',
      //   med: '#777777',
      //   low: '#DDDDDD',
      //   inv: '#000000'
      // }
    }
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography')
  ],
}