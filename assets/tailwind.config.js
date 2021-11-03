module.exports = {
  mode: 'jit', // https://tailwindcss.com/docs/just-in-time-mode
  purge: [
    "../**/*.html.eex",
    "../**/*.html.leex",
    "../**/views/**/*.ex",
    "../**/live/**/*.ex",
    "./js/**/*.js"
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
    container: {
      padding: {
        DEFAULT: '1rem',
        sm: '2rem',
        md: '1rem',
        lg: '4rem',
        xl: '1rem',
        '2xl': '1rem',
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
