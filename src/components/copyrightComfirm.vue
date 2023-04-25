<template>
  <div>

    <el-row class="lightgreen-box" style="height: px;" justify="center">
      <el-col :span="18">
        <el-image :src="imageUrl" style="width: 400px; height: 250px; border: 1px solid #ccc;"></el-image>
        <div style="text-align:  margin-top: 10px;">
          <el-button @click="uploadImage">Upload Img</el-button>
          <el-row>
            Img feature：{{ feature }}
          </el-row>
          <hr>
          <el-row v-if="showButtons">
            <el-button @click="uploadToIPFS">Upload to IPFS</el-button>
          </el-row>
          <el-row>
            IPFS address：{{ ipfsHash }}
          </el-row>
          <hr>
          <el-row v-if="showButtons">
            <div>
              <el-input v-model="info" placeholder="please input copyright info"></el-input>
              <el-button @click="confirmRights">Confirm</el-button>
            </div>
          </el-row>
        </div>

        <el-row v-if="showButtons && showCard">
          <el-card style="width: auto; height: auto; position: relative;" id="mycard">
            <el-container direction="vertical">
              <el-main>
                <img :src="imageUrl" style="width: 100%; height: 100%; object-fit: contain;" />
              </el-main>
              <el-main>
                <div class="text-info">
                  Img feature：{{ feature }}
                  <hr>
                  IPFS address：{{ ipfsHash }}
                  <hr>
                  Contract address：{{ contractAddress }}
                  <hr>
                  copyright info:{{ info }}
                </div>
              </el-main>
            </el-container>
            <img src="../assets/signature.png"
              style="position: absolute; top: 25%; left: 50%; width: 30%; height: 100%; object-fit: contain;" />
          </el-card>
          <el-col>
            <el-button @click="saveCardAsImage">Download</el-button>
          </el-col>

        </el-row>


        <input type="file" ref="fileInput" @change="handleFileChange" hidden />
      </el-col>

    </el-row>
  </div>
</template>

<script>
import { ElButton, ElImage, ElInput } from 'element-plus';
import ipfs from '../ipfs'
import Web3 from "web3";
import MyContract from '../assets/MyContract.json';
import KeyValueStore from '../assets/KeyValueStore.json';
import html2canvas from 'html2canvas';
import storeAdress from '../keyValueStore'

//配置子合约地址abi,bytecode等功能
const abi = MyContract.abi;
//const bytecode = MyContract.bytecode;

//配置父合约的地址abi,bytecode等功能
const Sabi = KeyValueStore.abi;
//const Sbytecode = KeyValueStore.bytecode;


export default {
  components: {
    ElButton,
    ElImage,
    ElInput
  },
  data() {
    return {
      imageData: '',
      feature: 'no img',
      showButtons: false,
      showCard: false,
      info: '',
      ipfsHash: 'not upload to IPFS',
      contractAddress: '',
      imageUrl:'https://cdn.pixabay.com/photo/2023/04/03/11/45/water-7896610_960_720.jpg'
    }
  },
  methods: {
    uploadImage() {
      this.$refs.fileInput.click();
    },
    async handleFileChange(event) {
      const file = event.target.files[0];
      if (file) {
        const reader = new FileReader();
        reader.onload = async e => {
          this.imageData = e.target.result;
          const buffer = e.target.result;
          const hashBuffer = await crypto.subtle.digest('SHA-256', buffer);
          const hashArray = Array.from(new Uint8Array(hashBuffer));
          this.feature = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
          this.showButtons = true;
          this.imageUrl = URL.createObjectURL(new Blob([buffer]));
        }
        reader.readAsArrayBuffer(file);
      }
    },
    async uploadToIPFS() {
      const file = await ipfs.add(this.imageData);
      this.ipfsHash = file.cid.toString();
    },
    async confirmRights() {
      const web3 = new Web3(window.ethereum);
      const accounts = await web3.eth.getAccounts();
      const feature = this.feature;
      const info = this.info;
      const contract = new web3.eth.Contract(Sabi, storeAdress);
    
      const self = this;
      contract.methods.setNewItem(feature, info).send(
        {
          from: accounts[0],
          gasPrice: "20000000000",
          gas: "6721975",
        }
      ).then(() => {
        contract.methods.findAddress(feature).call({
          from: accounts[0],
        }, function (error, result) {
          if (error) {
            console.log(error);
          } else {
            console.log(result);
            self.contractAddress = result;
          }


          const newContract = new web3.eth.Contract(
            abi,
            self.contractAddress
          );

          //使用newContract对象调用合约中的方法
          newContract.methods.setIPFShash(self.ipfsHash).send({
            from: accounts[0],
            gasPrice: "20000000000",
            gas: "6721975",
          });

          self.showCard = true;
        });
      })
    },
    saveCardAsImage() {
      const card = document.getElementById('mycard');
      html2canvas(card).then(canvas => {
        const dataURL = canvas.toDataURL();
        const link = document.createElement('a');
        link.href = dataURL;
        link.download = 'card.png';
        link.click();
      });
    }
  }
}
</script>
<style scoped>
.text-info {
  font-size: 10px;
}
</style>
