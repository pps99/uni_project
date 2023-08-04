<template>
  <div class="">
    <nav class="navbar navbar-expand-lg bg-body-tertiary">
      <div class="container-fluid">
        <a class="navbar-brand" href="#">Navbar</a>
        <div class="collapse navbar-collapse" id="navbarSupportedContent"> 
          <form class="d-flex">
            <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search" v-model="search">
            <button class="btn btn-outline-success"  @click.prevent="searchitem()">Search</button>
          </form>
          <cart_items_display ref="childRef" />
        </div>    
        <a @click="logout" href="#"><font-awesome-icon icon="reply" class="mr-2 text-danger" /> Logout</a>
      </div>
    </nav>

    <ul class="nav nav-tabs mb-5" id="myTab" role="tablist">
      <li class="nav-item" id="clk" role="" v-for="type_name in type_names" :key="type_name.id" >
        <button class="nav-link" @click="selectRelatedItems(type_name)" id="type_name" data-toggle="tab" data-target="" type="button" role="tab" aria-controls="" aria-selected="false">{{ type_name }}</button>
      </li>
    </ul>

    <div class="d-flex justify-content-start flex-wrap" style="width: 87.5%; margin: auto;">
      <div v-for="relateditem in relateditems" :key="relateditem.id" class="m-4" >
        <div class="card" style="width: 18rem;">
          <!-- <img src="..." class="card-img-top" alt="..."> -->
          <div class="card-body">
            <h5 class="card-title">{{ relateditem.name }}</h5>
            <p class="card-text">{{ relateditem.description }}</p>
            <p class="card-text">{{ relateditem.price }}</p>
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

export default {
  components: {
    BootstrapVueIcons,
    cart_items_display
  },
  data(){
    return{
      type_names: [],
      relateditems: [],
      items: [],
      cart_item:{
        quantity: '',
        cake_id: '',
        cake_name: '',
        unit_price: '',
      },
      quantities: [],
      search: ''
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
      this.cart_item.cake_id = relateditem.id
      this.cart_item.cake_name = relateditem.name
      this.cart_item.unit_price = relateditem.price
      if (this.cart_item.quantity == 0 ){
        return alert("Please Chose an Item");
      }
      this.$axios.post(`/cart_items`,this.cart_item)
        .then(response => {
          this.cart_item.quantity = 0;
          this.quantities.filter(quantity => {
            quantity.count = '0'
          })
          this.$refs.childRef.get_all_card_items();
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
    increment(id) {
      this.quantities.map( quantity => {
        if(quantity.id == id)
        {
          this.cart_item.quantity = ++quantity.count;
        }
      })
      
    },
    decrement(id) {
      this.quantities.map( quantity => {
        if(quantity.id == id && quantity.count !=0)
        {
          this.cart_item.quantity = --quantity.count;
        }
      })
    },
    searchitem(){
      this.$axios.post(`/cakes/search?search=${this.search}`)
        .then(response => {
          this.$router.push('#')
          console.log(response);
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

}
</script>

<style>
.card:hover {
  box-shadow: 8px 8px 16px 0 rgba(0, 0, 0, 0.2);
}

input[type=number]::-webkit-inner-spin-button,
input[type=number]::-webkit-outer-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
</style>