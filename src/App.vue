
  <template>
  <div class="common-layout">
    <el-container >
      <el-header class="centered-header">Blockchain and WarterMark Based copyright protection platform</el-header>
      
      <el-container style="background-color:antiquewhite;">
      <el-aside width="200px" >
        <el-menu >
         
          <el-menu-item index="2"  class="router">
            <router-link to="/myFirst" class="router-link">Index</router-link>
          </el-menu-item>

          <el-menu-item index="3 " class="router" >
            <router-link to="/cprc"  class="router-link">Copyright confirm</router-link>
          </el-menu-item>

          <el-menu-item index="4" class="router">
            <router-link to="/cprf"  class="router-link">Copyright find</router-link>
          </el-menu-item>

          <el-menu-item index="5" class="router">
            <router-link to="/wh"  class="router-link">My warehouse</router-link>
          </el-menu-item>

          <el-menu-item index="6" class="router">
            <router-link to="/market"  class="router-link">Market</router-link>
          </el-menu-item>

          <el-menu-item index="7" class="router">
            <router-link to="/confirm"  class="router-link">Confirm Transfer</router-link>
          </el-menu-item>

          <el-menu-item index="8" class="router">
            <router-link to="/Info"  class="router-link">My profile</router-link>
          </el-menu-item>
        </el-menu>
      </el-aside>
      <el-main>
        <el-scrollbar height='800px'>
          <router-view>
         
        </router-view>
        </el-scrollbar>
       
      </el-main>
      
    </el-container>
    </el-container>
  </div>
</template>
<script>

export default {
  name: 'App',
  components: {
  
  },
  data(){
    return {

    }
  }
}
</script>

<style>

.centered-header {
  text-align: center;
  font-size: 40px;
  height: 100px;
  background-color: bisque;
  
}
.router{
  background-color: #ddd3d3;
  color: #fff;
  padding: 100px;

}
.router-link {
  color: blue;
  text-decoration: none;
  
}
</style>
