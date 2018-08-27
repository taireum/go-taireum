<template>
  <main>
    <el-row :gutter="20" style="margin-bottom: 20px;margin-top: 100px;font-size:200%;">
      <el-col :span="16" :offset="6">您可以选择创建一个联盟或者加入一个联盟</el-col>
    </el-row>
    <el-row :gutter="20" style="margin-bottom: 20px;margin-top: 100px;">
      <el-col :span="12" :offset="10"><el-button type="primary" @click="handleCreate" icon="el-icon-circle-plus">&nbsp;&nbsp;创建联盟</el-button></el-col>
    </el-row>
    <el-row :gutter="20" style="margin-bottom: 20px;margin-top: 50px;">
      <el-col :span="12" :offset="10"><el-button type="primary" icon="el-icon-upload2" disabled>&nbsp;&nbsp;加入联盟</el-button></el-col>
    </el-row>
    <el-dialog title="创建联盟" :visible.sync="dialogFormVisible" width="40%">
      <el-form :rules="rules" ref="dataForm" :model="temp" label-position="left" label-width="100px" style='width: 400px; margin-left:50px;'>
        
        <el-form-item label="成员名称" prop="company">
          <el-input v-model="temp.company"></el-input>
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="temp.email"></el-input>
        </el-form-item>
        <el-form-item label="ChainID" prop="chainid">
          <el-input v-model="temp.chainid"></el-input>
        </el-form-item>
        <el-form-item label="联盟网络ID" prop="networkid">
          <el-input v-model="temp.networkid"></el-input>
        </el-form-item>
        <el-form-item label="RPC端口" prop="rpcport">
          <el-input v-model="temp.rpcport"></el-input>
        </el-form-item>
        <el-form-item label="本地节点url" prop="eth_url">
          <el-input v-model="temp.eth_url"></el-input>
        </el-form-item>
        <!-- <el-form-item label="默认奖励地址" prop="coinbase">
          <el-input v-model="temp.coinbase"></el-input>
        </el-form-item> -->
        <!-- <el-form-item label="CORS地址" prop="rpccorsdomain">
          <el-input v-model="temp.rpccorsdomain"></el-input>
        </el-form-item> -->
        <el-form-item label="存储路径" prop="datadir">
          <el-input v-model="temp.datadir"></el-input>
        </el-form-item>
        <el-form-item label="描述" prop="remark">
          <el-input type="textarea" :autosize="{ minRows: 2, maxRows: 4}" placeholder="Please input" v-model="temp.remark">
          </el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取消</el-button>
        <el-button type="primary" @click="createData">确认</el-button>
      </div>
    </el-dialog>
  </main>
</template>

<script>
  export default {
    data (){
      return {
        temp: {
          company: '',
          email: '',
          chainid: '',
          networkid: '',
          rpcport: '',
          // coinbase: '',
          // rpccorsdomain: '',
          eth_url: '',
          datadir: '',
          remark: ''
        },
        dialogFormVisible: false,
        rules: {
          company: [{ required: true, message: 'company is required', trigger: 'blur' }],
          email: [{ required: true, message: 'email is required', trigger: 'blur' }],
          chainid: [{ required: true, message: 'chainid is required', trigger: 'blur' }],
          networkid: [{ required: true, message: 'networkid is required', trigger: 'blur' }],
          rpcport: [{ required: true, message: 'rpcport is required', trigger: 'blur' }],
          coinbase: [{ required: true, message: 'coinbase is required', trigger: 'blur' }],
          rpccorsdomain: [{ required: true, message: 'rpccorsdomain is required', trigger: 'blur' }],
          datadir: [{ required: true, message: 'datadir is required', trigger: 'blur' }],
          remark: [{ required: true, message: 'remark is required', trigger: 'blur' }]
        }
      }
    },
    methods: {
      resetTemp() {
        this.temp = {
          company: '',
          email: '',
          chainid: '',
          networkid: '',
          rpcport: '',
          // coinbase: '',
          // rpccorsdomain: '',
          datadir: '',
          remark: ''
        }
      },
      handleCreate() {
        this.resetTemp()
        this.dialogFormVisible = true
        this.$nextTick(() => {
          this.$refs['dataForm'].clearValidate()
        })
      },
      createData() {
        this.$refs['dataForm'].validate((valid) => {
          if (valid) {
            this.axios.post('/api/v1', {
              source: 'ccc',
              method: 'setup',
              argv: {
                _company: this.temp.company,
                _email: this.temp.email,
                _chainid: this.temp.chainid,
                _networkid: this.temp.networkid,
                _datadir: this.temp.datadir,
                _rpcport: this.temp.rpcport,
                _eth_url: this.temp.eth_url,
                _remark: this.temp.remark
              }
            }).then(res => {
              console.log(res)
              this.dialogFormVisible = false
              this.$notify({
                title: '成功',
                message: '创建成功',
                type: 'success',
                duration: 2000
              })
            })
          }
        })
      }
    }
  }
</script>

<style scoped>
  /* .el-row {
    margin-bottom: 20px;
    margin-top: 50px;
  } */
  .el-col {
    border-radius: 4px;
  }
  .bg-purple {
    background: #166bcc;
  }
  .grid-content {
    border-radius: 4px;
    min-height: 80px;
  }
</style>
