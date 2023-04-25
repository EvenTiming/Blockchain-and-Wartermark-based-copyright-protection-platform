<template>
    <div v-for="item in items" :key="item">
        <el-card class="card">
            <el-image :src="item.IPFShash" v-if="item.IPFSstate == 1"></el-image>
            <p><strong>Image feature:</strong> {{ item.feature }}</p>
            <p><strong>Copyright Info:</strong>{{ item.info }}</p>
            <p v-if="item.IPFSstate == 1"><strong>IPFShash: </strong><a>{{ item.IPFShash }}</a></p>
            <p><strong>State: </strong>{{ item.state }}</p>
            <p><strong>Price: </strong>{{ item.price }}</p>
            <p><strong>Address: </strong>{{ item.address }}</p>
            <el-button type="primary" @click="confirmT(item.address)">Confirm Transfer</el-button>
        </el-card>
    </div>
</template>
  
<script>
import { ElButton, ElImage } from 'element-plus'
//import ipfs from '../ipfs'
import Web3 from "web3";
import MyContract from '../assets/MyContract.json';
import KeyValueStore from '../assets/KeyValueStore.json';
import storeAdress from '../keyValueStore'

const Sabi = KeyValueStore.abi;
//配置子合约地址abi,bytecode等功能
const abi = MyContract.abi;
export default {
    name: 'myConfirm',
    components: {
        ElButton,
        ElImage,
     
    },
    data() {
        return {
            items: [],
            imagedata: 'http://localhost:8082/ipfs/',
            showBox: false,
            SellPrice: 0,
            price: [],
        };
    },
    mounted() {
        this.getAllItems();
    },
    methods: {

        async getAllItems() {
            const self = this;
            const web3 = new Web3(window.ethereum);
            const accounts = await web3.eth.getAccounts();
            const contract = new web3.eth.Contract(Sabi, storeAdress);
            let length = await contract.methods.length().call();

            const conAddress = await contract.methods.getConAddress().call({
                from: accounts[0],
            });
            for (let i = 0; i < length; i++) {

                const Itemcotract = new web3.eth.Contract(abi, conAddress[i]);
                Itemcotract.methods.getInfo().call().then(function (result) {

                    if (result[0] == accounts[0]&&result[4]==2) {
                        var tempIPFShash = '';
                        var tempIPFSstate = 0;
                        if (result[3] == 'not upload to IPFS') {
                            tempIPFShash = '';
                            tempIPFSstate = 0;
                        } else {
                            tempIPFShash = self.imagedata + result[3];
                            tempIPFSstate = 1;
                        }
                        self.items.push({
                            feature: result[1],
                            info: result[2],
                            IPFShash: tempIPFShash,
                            IPFSstate: tempIPFSstate,
                            state: result[4],
                            price: result[5],
                            address: conAddress[i],
                            sellprice: '',
                        });
                    }
                })
            }

        },
        async confirmT(address){
            const web3 = new Web3(window.ethereum);
            const accounts = await web3.eth.getAccounts();
            const ItemContract = new web3.eth.Contract(abi, address);
            ItemContract.methods.confirm().send(
                {
                    from: accounts[0],
                    gasPrice: "20000000000",
                    gas: "6721975",
                }
            )
        }
    }
};
</script>
 
<style scoped>
.img {
    width: 300px;
    height: 200px;
    max-width: 100%;
    height: auto;
}

.card {
    width: 1000px;
    height: 600px;
    max-width: 100%;
    height: auto;
}</style>