<template>
    <div>
        <el-card v-for="item in items" :key="item" class="card">
            <el-image :src="item.IPFShash"></el-image>
            <p><strong>Owenr:</strong> {{ item.owner }}</p>
            <p><strong>Image feature:</strong> {{ item.feature }}</p>

            <p><strong>Copyright Info:</strong>{{ item.info }}</p>
            <p><strong>IPFShash: </strong><a>{{ item.IPFShash }}</a></p>
            <p><strong>State: </strong>{{ item.state }}</p>
            <p><strong>Price: </strong>{{ item.price }}</p>
            <p><strong>Address: </strong>{{ item.address }}</p>
            <el-input v-model="item.newInfo"></el-input>
            <el-button type="primary" @click="buyItem(item.address,item.newInfo,item.price)">But it !</el-button>



        </el-card>
    </div>
</template>
  
<script>
import { ElButton, ElImage, ElInput, } from 'element-plus'
//import ipfs from '../ipfs'
import Web3 from "web3";
import MyContract from '../assets/MyContract.json';
import KeyValueStore from '../assets/KeyValueStore.json';
import storeAdress from '../keyValueStore'
const Sabi = KeyValueStore.abi;

//配置子合约地址abi,bytecode等功能
const abi = MyContract.abi;
export default {
    name: 'myMarket',
    components: {
    ElButton,
    ElImage,
    ElInput
},
    data() {
        return {
            items: [],
            imagedata: 'http://localhost:8082/ipfs/',
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

                    if (result[4] == 1) {
                        console.log(self.imagedata + result[3])
                        self.items.push({
                            owner: result[0],
                            feature: result[1],
                            info: result[2],
                            IPFShash: self.imagedata + result[3],
                            state: result[4],
                            price: result[5],
                            address: conAddress[i],
                            newInfo:'',
                        });
                    }
                })
            }

        },
        async buyItem(address,newInfo,Value) {
            const web3 = new Web3(window.ethereum);
            const accounts = await web3.eth.getAccounts();
            const ItemContract = new web3.eth.Contract(abi, address);
            ItemContract.methods.buy(newInfo).send({
                value:Value,
                from: accounts[0],
                gasPrice: "20000000000",
                gas: "6721975",
            })
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
}
</style>