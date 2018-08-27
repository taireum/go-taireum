import Vue from 'vue'
import VueRouter from 'vue-router'
// import VueSocketio from 'vue-socket.io';
import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
import App from './App.vue'
import axios from 'axios'
import routes from './routes.js'

Vue.use(VueRouter)
Vue.use(ElementUI)
// Vue.use(VueSocketio, 'http://127.0.0.1:8000');
Vue.prototype.axios = axios
const router = new VueRouter({
  routes
})

new Vue({
  el: '#app',
  router,
  render: h => h(App)
})
