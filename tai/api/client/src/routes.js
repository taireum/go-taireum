'use strict'

export default [
	{
		path: '/block-overview',
		component (resolve) {
			require(['./pages/block-overview.vue'], resolve)
		},
		name: '区块概览'
	},
	{
		path: '/alliance-info',
		component (resolve) {
			require(['./pages/alliance-info.vue'], resolve)
		},
		name: '联盟信息'
	},
	{
		path: '/poa-list',
		component (resolve) {
			require(['./pages/poa-list.vue'], resolve)
		},
		name: 'POA成员列表'
	},
	{
		path: '/poa-vote',
		component (resolve) {
			require(['./pages/poa-vote.vue'], resolve)
		},
		name: 'POA投票平台'
	},
	{
	  path: '/poa-channel',
	  component (resolve) {
		  require(['./pages/poa-channel.vue'], resolve)
	  },
		name: 'POA通道管理'
	},
	{
		path: '/onekey-coalition',
		component (resolve) {
			require(['./pages/onekey-coalition.vue'], resolve)
		},
		name: '一键联盟'
	},
	{
		path: '/node-monitor',
		component (resolve) {
			require(['./pages/node-monitor.vue'], resolve)
		},
		name: '节点监控'
	},
	{
		path: '/smart-contract',
		component (resolve) {
			require(['./pages/smart-contract.vue'], resolve)
		},
		name: '智能合约'
	},
	{
		path: '/apis',
		component (resolve) {
			require(['./pages/apis.vue'], resolve)
		},
		name: 'APIs'
	},
	{
		path: '/block-browser',
		component (resolve) {
			require(['./pages/block-browser.vue'], resolve)
		},
		name: '智能合约'
	},
	{
		path: '/message-list',
		component (resolve) {
			require(['./pages/message-list.vue'], resolve)
		},
		name: '消息列表'
	},
	{
		path: '/release-notes',
		component (resolve) {
			require(['./pages/release-notes.vue'], resolve)
		},
		name: 'Release Notes'
	}
]
