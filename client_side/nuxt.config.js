export default {
  // Global page headers: https://go.nuxtjs.dev/config-head
  head: {
    title: 'Cake',
    htmlAttrs: {
      lang: 'en'
    },
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: '' },
      { name: 'format-detection', content: 'telephone=no' }
    ],
    link: [
      // { rel: 'icon', type: 'image/x-icon', href: 'http://127.0.0.1:8080/car.jpg' }
    ],
    script: [
      { src: "https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js" },
      { src: "https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js" },
      { src: "https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js" }
    ]
  },
  // Global CSS: https://go.nuxtjs.dev/config-css
  css: [
  ],

  // Plugins to run before rendering page: https://go.nuxtjs.dev/config-plugins
  plugins: [
    { src: '~/plugins/vue-notification.js', ssr: false },
    { src: '~/plugins/vue-datepicker', ssr: false },
  ],

  // Auto import components: https://go.nuxtjs.dev/config-components
  components: true,

  // Modules for dev and build (recommended): https://go.nuxtjs.dev/config-modules
  buildModules: [
    ['@nuxtjs/fontawesome', 
      {
        icons: {
          solid: true,
          regular: true,
          light: [],
          duotone: [],
          brands: []
        }
      }
    ],
  ],


  // Modules: https://go.nuxtjs.dev/config-modules
  modules: [
    // https://go.nuxtjs.dev/bootstrap
    'bootstrap-vue/nuxt',
    // https://go.nuxtjs.dev/axios
    {  src: '@nuxtjs/axios', mode: 'client' },
    { src: '@nuxtjs/auth-next', mode: 'client' },
  ],

  bootstrapVue: {
    icons: true
  },
  
  // Axios module configuration: https://go.nuxtjs.dev/config-axios
  axios: {
    baseURL: 'http://localhost:8080',
    headers: {
      common: {
        Accept: 'application/json, text/plain, */*'
      }
    }
  },

  auth: {
    redirect: {
          login: '/login',
        },
    strategies: {
      local:{
        token: {
          property: 'data.token',
          maxAge: 18000,
          global: true,
          name: 'Authorization',
          type: 'Bearer'
        },
        user: {
          property: false,
          autoFetch: true
        },
        endpoints: {
          login: {url: '/login', method: 'post' },
          logout: {url: '/logout', method: 'post'},
          user: {url: '/user', method: 'get' },
        }
      }
    }
  },

  // Build Configuration: https://go.nuxtjs.dev/config-build
  build: {
    transpile: [
      'defu'
    ]
  },
  
  router: {
    middleware: ['auth']
  },

  generate: {
    routes: [
      '/passwordreset',
      '/forgotpassword'
    ],
  },
  'passwordreset': {
    middleware: false,
  },
  'forgotpassword': {
    middleware: false,
  }
}
