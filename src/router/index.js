
import { createWebHistory, createRouter } from 'vue-router'

import myFirst from '../components/myFirst.vue'
import copyrightComfirm from '../components/copyrightComfirm.vue'
import myInformation from '../components/myInformation.vue'
import copyrightFind from '../components/copyrightFind.vue'
import wareHouse from '../components/wareHouse.vue'
import myMarket from '../components/myMarket.vue'
import myConfirm from '../components/myConfirm.vue'
//import store from '../store';
const routes = [{
    path: '/myFirst',
    component: myFirst
},
{
    path: '/cprc',
    component: copyrightComfirm
},
{
    path: '/Info',
    component: myInformation
},
{
    path: '/cprf',
    component: copyrightFind
},
{
    path: '/wh',
    component: wareHouse
},{
    path: '/market',
    component: myMarket
},
{
    path: '/confirm',
    component: myConfirm
},
]
const router = createRouter({
    history: createWebHistory(),
    routes,
})

// router.beforeEach((to, from, next) => {
//     if (to.path !== '/Login' && !store.state.Islogin) {
//       next({ path:'/Login'  });
//     } else {
//       next();
//     }
//   });

export default router;