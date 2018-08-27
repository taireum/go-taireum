<template>
    <aside  class="el-aside menu" :style="isCollapse?'':'width: 200px;'">
      <!-- <el-radio-group v-model="isCollapse" style="margin-bottom: 20px;">
        <el-radio-button :label="false">展开</el-radio-button>
        <el-radio-button :label="true">收起</el-radio-button>
      </el-radio-group> -->
      <el-menu :default-active="onRoutes" unique-opened router class="el-menu-vertical-demo">
        <template v-for="item in items">
          <template v-if="item.subs">
            <el-submenu :index="item.index">
                <template slot="title">
                  <i :class="'el-'+item.icon"></i>
                  <span slot="title">{{ item.title }}</span>
                </template>
                <el-menu-item v-for="(subItem,i) in item.subs" :key="i" :index="subItem.index">{{ subItem.title }}</el-menu-item>
            </el-submenu>
          </template>
          <template v-else>
            <el-menu-item :index="item.index">
                <i :class="'el-'+item.icon"></i>
                <span slot="title">{{ item.title }}</span>
            </el-menu-item>
          </template>
        </template>
      </el-menu>
    </aside>
</template>

<script>
  export default {
    data () {
      return {
        isCollapse: false,
        items: [{
          icon: 'icon-menu',
          title: '概览',
          index: '1',
          subs: [{
            index: '/block-overview',
            title: '区块概览'
          }, {
            index: '/alliance-info',
            title: '联盟信息'
          }]
        }, {
          icon: 'icon-news',
          title: '联盟管理',
          index: '2',
          subs: [{
            index: '/poa-list',
            title: '成员列表'
          }, {
            index: '/poa-vote',
            title: '投票平台'
          }, {
            index: '/poa-channel',
            title: '通道管理'
          }]
        }, {
          icon: 'icon-more-outline',
          title: '区块链',
          index: '3',
          subs: [{
            index: '/onekey-coalition',
            title: '一键联盟'
          }, {
            index: '/node-monitor',
            title: '节点监控'
          }, {
            index: '/smart-contract',
            title: '智能合约'
          }, {
            index: '/apis',
            title: 'APIs'
          }, {
            index: '/block-browser',
            title: '区块链浏览器'
          }]
        }, {
          icon: 'icon-message',
          title: '消息管理',
          index: '4',
          subs: [{
            index: '/message-list',
            title: '消息列表'
          }]
        }, {
          icon: 'icon-location',
          title: '社区支持',
          index: '5',
          subs: [{
            index: '/release-notes',
            title: 'Release Notes'
          }]
        }]
      }
    },
    computed:{
      onRoutes(){
        return this.$route.path;
      }
    }
  }
</script>

<style scoped>
  
</style>
