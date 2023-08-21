<template>
  <div class="">
    <nav class="navbar navbar-expand-lg bg-body-tertiary">
      <div class="container-fluid">
        <a class="navbar-brand" href="#">CakeShop</a>
        <div class="collapse navbar-collapse" id="navbarSupportedContent"> 
          <form class="d-flex">
            <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search" v-model="search">
            <button class="btn btn-outline-success"  @click.prevent="searchitem()">Search</button>
          </form>
          <cart_items_display ref="childRef" :cart_items="cart_items" :shouldDisableLink="shouldDisableLink" />
        </div>
        <profile_avatar />
      </div>
    </nav>

    <ul class="nav nav-tabs mb-5" id="myTab" role="tablist">
      <li class="nav-item" role="" v-for="type_name in type_names" :key="type_name.id">
        <button
          class="nav-link"
          @click="selectRelatedItems(type_name)"
          :id="type_name"
          data-toggle="tab"
          data-target=""
          type="button"
          role="tab"
          aria-controls=""
          :class="{ active: type_name === activeNavItem }"
        >
          {{ type_name }}
        </button>
      </li>
    </ul>

    <div class="d-flex justify-content-start flex-wrap" style="width: 87.5%; margin: auto;">
      <div v-for="relateditem in relateditems" :key="relateditem.id" class="m-4" >
        <div class="card" style="width: 18rem;">
          <img :src="relateditem.image_url" class="card-img-top img-thumbnail" style="height: 30vh;" alt="relateditem.name">
          <div class="card-body">
            <h5 class="card-title">{{ relateditem.name }}</h5>
            <p class="card-text">{{ relateditem.description }}</p>
            <p class="card-text">MMK {{ relateditem.price }}</p>
            <div style="width: 60%;" class="d-flex">
              <button @click="decrement(relateditem.id)" class="rounded-circle px-2 mr-2">
                  <b-icon icon="dash" aria-hidden="true"></b-icon> 
              </button> 
              <div v-for="quantity in quantities" :key="quantity.id" v-show="relateditem.id == quantity.id">
                <b-form-input type="number" class="text-right" min="0.00" :value="quantity.count">{{ quantity.count  }}</b-form-input>
              </div>
              
              <button @click="increment(relateditem.id)" class="rounded-circle px-2 ml-2">
                  <b-icon icon="plus" aria-hidden="true"></b-icon> 
              </button> 
            </div>
            <div class="clearfix">
              <button class="float-right mt-2 btn btn-primary"  @click="create_cart_item(relateditem)" >Add to cart</button>
            </div>
          </div>
       </div>
      </div>
    </div>

  </div>
</template>

<script>
import { BootstrapVueIcons } from 'bootstrap-vue'
import cart_items_display from './sub_pages/cart_items_display.vue'
import profile_avatar from './sub_pages/profile_avatar.vue'
export default {
  components: {
    BootstrapVueIcons,
    cart_items_display,
    profile_avatar
  },
  data(){
    return{
      type_names: [],
      relateditems: [],
      items: [],
      cart_items: [],
      quantities: [],
      search: '',
      quantity: '',
      shouldDisableLink: false,
      activeNavItem: ''
    }
  },
  methods: {
    async logout(){
      await this.$auth.logout();
      this.$notify({
          title: 'Success',
          text: 'Logout successful',
        });
      this.$router.push('/login')
    },
    url(image){
      return `http://127.0.0.1:8080${image}`
    },  
    selectRelatedItems(type_name) {
      this.quantities = []
      this.relateditems = []
      this.items.filter(item =>{
        if (item.type_name == type_name){
          this.relateditems.push(item)
          this.quantities.push({'id':item.id, 'count': 0})
        }
      })
    },
    create_cart_item(relateditem){ 
      if (this.quantity == 0 ){
        return alert("Please Chose an Item");
      }
      let present = false
      const newItem = {
          id: this.cart_items.length + 1,
          cake_id: relateditem.id,
          cake_name: relateditem.name,
          unit_price: relateditem.price,
          quantity: this.quantity
        };
      this.cart_items.filter(cart_item => {
        if(cart_item.cake_id == newItem.cake_id)
        {
          cart_item.quantity += newItem.quantity
          present = true
        }
      })
      if (!present){
      this.cart_items = [...this.cart_items, newItem]
      }
      this.quantity = 0;
      this.quantities.filter(quantity => {
            quantity.count = '0'
          })
      // this.$refs.childRef.get_all_card_items();
    },
    increment(id) {
      this.quantities.map( quantity => {
        if(quantity.id == id)
        {
          this.quantity = ++quantity.count;
        }
      })
    },
    decrement(id) {
      this.quantities.map( quantity => {
        if(quantity.id == id && quantity.count !=0)
        {
          this.quantity = --quantity.count;
        }
      })
    },
    searchitem(){
      this.$axios.post(`/cakes/search?search=${this.search}`)
        .then(response => {
          this.$router.push('#')
          this.type_names = response.data.type_names
          this.items = response.data.items
          this.selectRelatedItems(this.type_names[0])
          this.search = ''
        })
        .catch(error => {
          this.$notify({
            title: 'Fail',
            text: 'Something went wrong. Please try again',
            type: 'error'
          });
          this.errors = error.response.data.error
          this.errorMessage = true
        })
    },
  },

  mounted() {
    this.$axios.get(`/items`)
        .then(response => {
          this.items = response.data.items
          this.type_names = response.data.type_names
          this.selectRelatedItems(this.type_names[0])
          if (this.type_names.length > 0) {
            this.activeNavItem = this.type_names[0];
          }
        })
        .catch(error => {
          this.$notify({
            title: 'Fail',
            text: 'Something went wrong. Please try again',
            type: 'error'
          });
          this.errors = error.response.data.error
          this.errorMessage = true
        })
    if(localStorage.getItem('cart_items')){
      this.cart_items = JSON.parse(localStorage.getItem('cart_items'))
    }
    this.$axios.get(`user/`)
      .then(response => {
          if (response.data.user.status == 'pending'){
            this.shouldDisableLink = true
          }
        })
      .catch(error => {
          this.$notify({
            title: 'Fail',
            text: 'Something went wrong. Please try again',
            type: 'error'
          });
          this.errors = error.response.data.error
          this.errorMessage = true
        })

  },
  watch: {
    cart_items: {
      handler() {
        localStorage.setItem('cart_items', JSON.stringify(this.cart_items))
      },
      deep: true,
    },
  }

}
</script>

<style scoped>
  .card:hover {
    box-shadow: 8px 8px 16px 0 rgba(0, 0, 0, 0.2);
    transform: scale(1.1); /* Enlarge the card on hover */
  }

  input[type=number]::-webkit-inner-spin-button,
  input[type=number]::-webkit-outer-spin-button {
    -webkit-appearance: none;
    margin: 0;
  }
</style>