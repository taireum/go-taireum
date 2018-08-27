<template>
  <header class="el-header ccc-heaher">
    <img :src="require('../assets/logo.svg')" class="header-logo">
    <ul class="header-operations">
      <li>联盟设置</li> 
      <li>联盟消息</li> 
    </ul>
  </header>
</template>
<script>
  export default {
    data (){
      return {
        username: ''
      }
    },
    methods: {
      handleCommand(command) {
        switch (command) {
          case 'signout':
            break;
          case 'set':
            break;
        }
      }
    },
    mounted: function() {
      // this.axios('/index/username').then(res => {
      //   this.username = res.data.data
      // })
    }
  }
</script>

<style scoped>
  .header-logo {
    display: inline-block;
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
  }
  .ccc-heaher {
    height: 80px; 
    background-color: rgb(64, 158, 255);
    position:relative;
  }
  ul {
    display: block;
    list-style-type: disc;
    -webkit-margin-before: 1em;
    -webkit-margin-after: 1em;
    -webkit-margin-start: 0px;
    -webkit-margin-end: 0px;
    -webkit-padding-start: 40px;
    padding: 0;
    margin: 0;
  }
  .header-operations {
    display: inline-block;
    float: right;
    padding-right: 30px;
    height: 100%;
  }
  .header-operations li {
    color: #fff;
    display: inline-block;
    vertical-align: middle;
    padding: 0 10px;
    margin: 0 10px;
    line-height: 80px;
    cursor: pointer;
  }

</style>
