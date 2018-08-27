<template>
  <main>
    <el-button style="margin-left: 10px;" @click="handleCreate" type="primary">添加机构</el-button>
    <el-table
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
        prop="enode"
        label="节点地址地址">
      </el-table-column>
      <el-table-column
        prop="stat"
        label="状态">
      </el-table-column>
      <el-table-column
        prop="mine"
        label="能否挖矿">
      </el-table-column>
      <el-table-column
        fixed="right"
        label="操作"
        width="100">
        <template slot-scope="scope">
          <el-button @click="handleUpdate(scope.row)" type="primary" size="small" v-if="scope.row.owner.toLocaleLowerCase() == coinbase.toLocaleLowerCase()">编辑</el-button>
          <el-button @click="handleMine(scope.row)" type="primary" size="small" v-if="scope.row.mine === 'false' && mines.indexOf(coinbase) > -1">投票</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-dialog 
      v-loading.fullscreen.lock="loading"
      element-loading-text="拼命上链中"
      element-loading-spinner="el-icon-loading"
      element-loading-background="rgba(0, 0, 0, 0.8)"
      :title="textMap[dialogStatus]" 
      :visible.sync="dialogFormVisible"
      width="40%">
      <el-form :rules="rules" ref="dataForm" :model="temp" label-position="left" label-width="100px" style='width: 400px; margin-left:50px;'>
        
        <!-- <el-form-item label="公司ID" prop="companyid">
          <el-input v-model="temp.companyid"></el-input>
        </el-form-item> -->
        <el-form-item label="公司名" prop="companyname">
          <el-input v-model="temp.companyname"></el-input>
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="temp.email"></el-input>
        </el-form-item>
        <el-form-item label="节点信息" prop="enode">
          <el-input v-model="temp.enode"></el-input>
        </el-form-item>
        <el-form-item label="所有者" prop="owner">
          <el-input v-model="temp.owner"></el-input>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input type="textarea" :autosize="{ minRows: 2, maxRows: 4}" placeholder="Please input" v-model="temp.remark">
          </el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取消</el-button>
        <el-button v-if="dialogStatus=='create'" type="primary" @click="createData">确认</el-button>
        <el-button v-else type="primary" @click="updateData">确认</el-button>
      </div>
    </el-dialog>
  </main>
</template>

<script>
  import _ from 'lodash'
  export default {
    data (){
      return {
        members: [],
        enodes: [],
        mines: [],
        coinbase: '',
        companyid: null,
        loading: false,
        temp: {
          companyid: '',
          from: '',
          companyname: '',
          email: '',
          enode: '',
          owner: '',
          remark: ''
        },
        dialogFormVisible: false,
        dialogStatus: '',
        textMap: {
          update: 'Edit',
          create: 'Create'
        },
        rules: {
          // from: [{ required: true, message: 'from is required', trigger: 'change' }],
          companyname: [{ required: true, message: 'companyname is required', trigger: 'blur' }],
          email: [{ required: true, message: 'email is required', trigger: 'blur' }],
          enode: [{ required: true, message: 'enode is required', trigger: 'blur' }],
          owner: [{ required: true, message: 'owner is required', trigger: 'blur' }],
          remark: [{ required: true, message: 'remark is required', trigger: 'blur' }]
        }
      }
    },
    methods: {
      queryList() {
        return this.axios('/api/company').then(res => {
          // this.members = _.filter(res.data, ['stat', '1']);
          res.data.map(member => {
            if (member.owner.toLowerCase() == this.coinbase.toLowerCase()) this.companyid = member.companyid
            if (_.indexOf(this.mines, member.owner) > -1) {
              member.mine = 'true'
            } else {
              member.mine ='false'
            }
            if (_.indexOf(this.enodes, member.enode) > -1) {
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
      queryMines() {
        return this.axios('/api/mine').then(res => {
          console.log(res)
          this.mines = res.data
        })
      },
      resetTemp() {
        this.temp = {
          from: '',
          companyname: '',
          email: '',
          enode: '',
          owner: '',
          remark: ''
        }
      },
      handleCreate() {
        this.resetTemp()
        this.dialogStatus = 'create'
        this.dialogFormVisible = true
        this.$nextTick(() => {
          this.$refs['dataForm'].clearValidate()
        })
      },
      createData() {
        this.$refs['dataForm'].validate((valid) => {
          if (valid) {
            this.loading = true
            this.axios.post('/api/v1', {
              source: 'ccc',
              method: 'add',
              argv: {
                _from: this.coinbase,
                _companyname: this.temp.companyname,
                _email: this.temp.email,
                _enode: this.temp.enode,
                _address: this.temp.owner,
                _remark: this.temp.remark
              }
            }).then(res => {
              this.loading = false
              this.dialogFormVisible = false
              this.$notify({
                title: '成功',
                message: res.data.message,
                type: 'success',
                duration: 2000
              })
            })
          }
        })
      },
      handleUpdate(row) {
        this.temp = Object.assign({}, row) // copy obj
        this.temp.timestamp = new Date(this.temp.timestamp)
        this.dialogStatus = 'update'
        this.dialogFormVisible = true
        this.$nextTick(() => {
          this.$refs['dataForm'].clearValidate()
        })
      },
      updateData() {
        this.$refs['dataForm'].validate((valid) => {
          if (valid) {
            this.loading = true
            const tempData = Object.assign({}, this.temp)
            tempData.timestamp = +new Date(tempData.timestamp) // change Thu Nov 30 2017 16:41:05 GMT+0800 (CST) to 1512031311464
            this.axios.post('/api/v1', {
              source: 'ccc',
              method: 'update',
              argv: {
                _from: this.coinbase,
                _companyid: this.temp.companyid,
                _email: this.temp.email,
                _enode: this.temp.enode,
                // _address: this.temp.owner,
                _remark: this.temp.remark,
                _stat: 1
              }
            }).then(res => {
              this.loading = false
              this.dialogFormVisible = false
              this.$notify({
                title: '成功',
                message: res.data.message,
                type: 'success',
                duration: 2000
              })
            })
          }
        })
      },
      handleMine(row, vote) {
        this.loading = true
        this.axios.post('/api/v1', {
            "source": "ccc",
            "method": "minevote",
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
      await this.queryMines()
      await this.queryList()
    }
    
  }
</script>

<style scoped>

</style>
