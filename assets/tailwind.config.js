module.exports = {
  mode: 'jit', // https://tailwindcss.com/docs/just-in-time-mode
  content: [
    './js/**/*.js',
    '../lib/*_web/**/*.*ex'
  ],
  theme: {
    boxShadow: {
        DEFAULT: '0px 0.5px 0.5px rgba(0, 0, 0, 0.25)'
      },
     fontFamily: {
      'sans': ['Helvetica']},
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/forms'),
  ],
}
