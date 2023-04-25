<template>
    <el-carousel :interval="4000" type="card" height="500px">
        <el-carousel-item v-for="item in items" :key="item" class="itemcalss1">
            <h3 justify="center" class="font">{{ item.content }} </h3>
        </el-carousel-item>
    </el-carousel>
    
</template>

<script>

export default {
    name: 'myFirst',
    components: {
       
    },
    data() {
        return {
            items: [
                { content: "Safe" },
                { content: 'friendly' },
                { content: 'open source' }
            ]
        }
    }
}
</script>

<style scoped>
.itemcalss1 {
    color: #475669;
    line-height: 200px;
    margin: 0;
    text-align: center;
    background: url('https://cdn.pixabay.com/photo/2020/10/14/16/14/space-5654794_960_720.png');
}

.font {
    font-size: 50px;
    color: #000;
}
</style>
