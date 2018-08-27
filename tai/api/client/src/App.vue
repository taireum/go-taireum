<template>
  <section id="app" class="el-container wrapper is-vertical">
    <HeadBar></HeadBar>
    <section class="el-container">
      <SideBar></SideBar>
      <router-view class="el-main content"></router-view>
    </section>
  </section>
</template>

<script>
import HeadBar from './components/headbar.vue'
import SideBar from './components/sidebar.vue'
export default {
  data (){
    return {
      
    }
  },
  mounted: function() {
    
  },
  // sockets:{
  //   connect: function(){
  //     console.log('socket connected')
  //   },
  //   addMember: function(val){
  //     console.log(val)
  //   }
  // },
  methods: {
    
  },
  components: {
    HeadBar, SideBar
  }
}
</script>

<style>
  body {
    width: 100%;
    margin: 0px;
  }
  .el-menu, body, html, body>section {
    height: 100%;
  }
</style>
