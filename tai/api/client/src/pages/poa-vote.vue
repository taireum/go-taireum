<template>
  <main>
    <el-table
      v-loading.fullscreen.lock="loading"
      element-loading-text="拼命上链中"
      element-loading-spinner="el-icon-loading"
      element-loading-background="rgba(0, 0, 0, 0.8)"
      :data="members"
      style="width: 100%">
      <el-table-column
        prop="companyid"
        label="ID"
        width="180">
      </el-table-column>
      <el-table-column
        prop="companyname"
        label="公司名"
        width="180">
      </el-table-column>
      <el-table-column
        prop="email"
        label="email">
      </el-table-column>
      <el-table-column
        prop="remark"
        label="备注">
      </el-table-column>
      <el-table-column
        prop="owner"
        label="所有者地址">
      </el-table-column>
      <el-table-column
        prop="stat"
        label="状态">
      </el-table-column>
      <el-table-column
        fixed="right"
        label="操作"
        width="180">
        <template slot-scope="scope">
          <el-button @click="handleClick(scope.row)" type="success" size="small">投票</el-button>
          <!-- <el-button @click="handleClick(scope.row, false)" type="danger" size="small">反对</el-button> -->
        </template>
      </el-table-column>
    </el-table>
  </main>
</template>

<script>
  import _ from 'lodash'
  export default {
    data (){
      return {
        members: [],
        loading: false,
        coinbase: '',
        companyid: null
      }
    },
    methods: {
      queryList() {
        return this.axios('/api/company').then(res => {
          res.data.map(member => {
            if (member.owner.toLowerCase() == this.coinbase.toLowerCase()) this.companyid = member.companyid
            if (_.indexOf(this.enodes, member.enode) == -1) {
              this.members.push(member)
            }
          })
        })
      },
      queryCoinbase() {
        return this.axios('/api/coinbase').then(res => {
          console.log(res)
          this.coinbase = res.data.message
        })
      },
      queryEnodes() {
        return this.axios('/api/enode').then(res => {
          console.log(res)
          this.enodes = res.data
        })
      },
      handleClick(row) {
        this.loading = true
        this.axios.post('/api/v1', {
            "source": "ccc",
            "method": "vote",
            "argv": {
                "_from": this.coinbase,
                "_fromcompanyid":this.companyid,
                "_tocompanyid": row.companyid
            }
        })
        .then(res => {
          this.loading = false
          console.log(res);
          this.$notify({
                title: '成功',
                message: res.data.message,
                type: 'success',
                duration: 2000
              })
        })
        .catch(error => {
          console.log(error);
        });
      }
    },
    mounted: async function() {
      await this.queryCoinbase()
      await this.queryEnodes()
      await this.queryList()
    }
    
  }
</script>

<style scoped>

</style>
