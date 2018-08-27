<template>
	<iframe src='https://remix.ethereum.org/#optimize=false&version=soljson-v0.4.24+commit.e67f0147.js' class="iframe" ref="iframe" v-loading.fullscreen.lock="fullscreenLoading" element-loading-text="拼命加载中"></iframe>  
</template>

<script>
export default {
  name: 'myiframe',
  data() {
    return {
      fullscreenLoading: false
    }
  },
  created() {
    this.fullscreenLoading = true
  },
  mounted() {
    this.iframeInit()
    window.onresize = () => {
      this.iframeInit()
    }
  },
  components: {},
  methods: {
    iframeInit() {
      const iframe = this.$refs.iframe
      const clientHeight = document.documentElement.clientHeight - 90
      iframe.style.height = `${clientHeight}px`
      if (iframe.attachEvent) {
        iframe.attachEvent('onload', () => {
          this.fullscreenLoading = false
        })
      } else {
        iframe.onload = () => {
          this.fullscreenLoading = false
        }
      }
    }
  }
}
</script>

<style>
.iframe {
  width: 100%;
  height: 100%;
  border: 0;
  overflow: hidden;
  box-sizing: border-box;
}
</style>