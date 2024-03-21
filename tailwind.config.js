import defaultTheme from 'tailwindcss/defaultTheme'

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/frontend/**/*.{js,jsx,ts,tsx,css}',
    './app/components/**/*.{rb,erb,haml,html,slim}',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans]
      }
    },
    borderRadius: {
      'none': '0',
      'sm': '0.125rem',
      DEFAULT: '0.75rem',
      'md': '0.375rem',
      'lg': '0.5rem',
      'xl': '0.75rem',
      'full': '9999px',
      'large': '12px',
    },
    // colors: {
    //   'gray-50': '#f9f9f9',
    //   'gray-100': '#f5f5f5',
    //   'gray-200': '#e5e5e5',
    //   'gray-300': '#d4d4d4',
    //   'gray-400': '#b3b3b3',
    //   'gray-500': '#999999',
    //   'gray-600': '#7a7a7a',
    //   'gray-700': '#666666',
    //   'gray-800': '#4c4c4c',
    //   'gray-900': '#0e0e0e',
    // }
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries')
  ]
}
