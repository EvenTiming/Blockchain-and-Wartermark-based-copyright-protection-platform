<template>
    <div>
        
        <el-input v-model="feature" placeholder="please input img feature"></el-input>
        <el-button type="primary" @click="callContract">Find</el-button>
        <div id="timeline">
            <h1>Copyright Information (lastest)</h1>
            <el-card style="background-color: #9F9C99;">
                <p><strong>feature:</strong> {{ feature }}</p>
                <p><strong>contractAddress:</strong> {{ contractAddress }}</p>
                <p><strong>owner:</strong> {{ owner }}</p>
                <p><strong>copyrightInfo:</strong> {{ info }}</p>
                <p><strong>IPFShash:</strong> {{ IPFShash }}</p>
                <p><strong>state:</strong> {{ state }}</p>
                <p><strong>Last price:</strong> {{ price }}</p>
            </el-card>
            <hr>
            <h1>Copyright Transfer History</h1>
            <el-timeline>

                <el-timeline-item v-for="(item, index) in timelineData" :key="index" :timestamp="item.timestamp"
                    :color="item.cardcolor">
                    <el-card :style="{ backgroundColor: item.cardcolor }">
                        <h1><strong>{{ item.eventname }}</strong></h1>
                        <p>TX hash: {{ item.transhash }}</p>
                        <p style="white-space: pre-wrap;">{{ item.content }}</p>
                    </el-card>
                </el-timeline-item>

            </el-timeline>
        </div>

        <el-button type="primary" @click="generatePDF" v-if="show">Download</el-button>

    </div>
</template>
  
<script>
import { ElInput, ElButton } from 'element-plus'
//import pdf from 'vue-pdf';
// //import ipfs from '../ipfs'

import jsPDF from 'jspdf';
import html2canvas from 'html2canvas';
import Web3 from "web3";
import MyContract from '../assets/MyContract.json';
import KeyValueStore from '../assets/KeyValueStore.json';
import storeAdress from '../keyValueStore'
const Sabi = KeyValueStore.abi;


//配置子合约地址abi,bytecode等功能
const abi = MyContract.abi;
export default {
    name: 'MyComponent',
    components: {
        ElInput,
        ElButton,

    },
    data() {
        return {
            //input feature
            feature: '',
            //where item stored on blockchain
            contractAddress: 'null',
            owner: 'null',
            info: 'null',
            IPFShash: '',
            state: 0,
            price: '',
            show: false,
            timelineData: [],
        }
    },
    methods: {

        async callContract() {
            const web3 = new Web3(window.ethereum);
            const accounts = await web3.eth.getAccounts();
            const contract = new web3.eth.Contract(Sabi, storeAdress);
            const feature = this.feature;
            const self = this;
            contract.methods.findAddress(feature).call(
                {
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

                    newContract.methods.getInfo().call(
                        {
                            from: accounts[0],
                        }, function (error, receive) {
                            if (error) {
                                console.log(error);
                            } else {
                                console.log(receive);
                                self.owner = receive[0];
                                self.info = receive[2];
                                self.IPFShash = receive[3];
                                self.state = receive[4];
                                self.price = receive[5];
                            }
                        }
                    )
                    newContract.getPastEvents('allEvents', {
                        fromBlock: 0,
                        toBlock: 'latest'
                    }, function (error, events) {
                        if (error) {
                            console.log(error);

                        } else {
                            self.show = true;
                            self.timelineData=[];
                            events.forEach(function (event) {
                                web3.eth.getBlock(event.blockNumber, function (error, block) {
                                    var timestamp = block.timestamp;
                                    var date = new Date(timestamp * 1000);
                                    var eventName = '';
                                    var eventContent = '';
                                    var cardtype = '';
                    
                                    if (event.event === 'ItemOnChain') {
                                        eventName = 'Item is uploaded to the blockchain';
                                        eventContent = 'feature: ' + event.returnValues[0];
                                        eventContent += '\ncopyrightInfo: ' + event.returnValues[1];
                                        cardtype = '#FF6F61';
                                    } else if (event.event === 'ItemOnSell') {
                                        eventName = 'Item is sold';
                                        eventContent = 'selling price: ' + event.returnValues[0];
                                        cardtype = '#88B04B';
                                    } else if (event.event === 'ItemBought') {
                                        eventName = 'Item is bought';
                                        eventContent = 'buyer: ' + event.returnValues[0];
                                        eventContent += '\nnew copyrightInfo: ' + event.returnValues[1];
                                        cardtype = ' #F7CAC9';
                                    } else if (event.event === 'ItemChangeOwner') {
                                        eventName = 'Ownership of the item is transferred ';
                                        eventContent = 'from: ' + event.returnValues[0] + '\n';
                                        eventContent += 'to: ' + event.returnValues[1];
                                        cardtype = ' #92A8D1';
                                    } else if (event.event === 'ItemConfirm') {
                                        eventName = 'copyright transformation is done';
                                        cardtype = '#935529';
                                    } else if (event.event === 'ItemRevet') {
                                        eventName = 'copyright transformation is aborted';
                                        cardtype = '#ffdf9d';
                                    } else if (event.event === 'IPFShashSetted') {
                                        eventName = 'IPFS state';
                                        eventContent ='IPFS hash: '+event.returnValues[0];
                                        cardtype = '#5eaac1';
                                    }

                                    
                                    self.timelineData.push({
                                        timestamp: date.toUTCString(),
                                        eventname: eventName,
                                        transhash: event.transactionHash,
                                        content: eventContent,
                                        cardcolor: cardtype,
                                    });
                                });
                            });
                        }
                    });

                }
            )
        },

        generatePDF() {
            var element = document.getElementById('timeline');

            html2canvas(element).then((canvas) => {
                var imgData = canvas.toDataURL('image/png');
                var doc = new jsPDF();
                doc.addImage(imgData, 'PNG', 0, 0);
                doc.save('test.pdf');
            });
        }
    }
}
</script>
  
<style scoped></style>