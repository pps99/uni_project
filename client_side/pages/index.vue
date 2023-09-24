<template>
  <div class="index-container">
    <div class="fixed-top" style="z-index: 100;" >
      <nav class="navbar navbar-expand-lg bg-body-tertiary ">
        <div class="container-fluid">
          <a class="navbar-brand" href="#">CakeShop</a>
          <div class="d-flex">
            <div class="collapse navbar-collapse" id="navbarSupportedContent"> 
              <form class="d-flex">
                <input class="form-control me-2 reduced-opacity" style="width: 300px;" type="search" placeholder="Search" aria-label="Search" v-model="search">
                <button class="btn btn-secondary ml-2"  @click.prevent="searchitem()">Search</button>
              </form>
              <cart_items_display ref="childRef" :cart_items="cart_items" :shouldDisableLink="shouldDisableLink" :amount="amount" />
            </div>
            <profile_avatar v-if="$auth.loggedIn" :amount="amount" />
            <button v-else class="float-right mt-2 btn btn-info" @click="loggedIn"> Log In </button>
          </div>
        </div>
      </nav>

      <ul class="nav nav-tabs mb-5" id="myTab" role="tablist">
        <li class="nav-item" role="" v-for="type_name in type_names" :key="type_name.id">
          <button
            class="nav-link reduced-opacity"
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
    </div>

    <div class="card-container d-flex flex-wrap overflow-auto">
      <div v-for="relateditem in relateditems" :key="relateditem.id" class="col-md-3 mb-4">
        <div class="card" style="border-radius: 25px;">
          <img :src="relateditem.image_url" class="card-img-top" style=" border-radius: 25px; height: 150px; " :alt="relateditem.name">
          <div class="card-body">
            <h5 class="card-title">{{ relateditem.name }}</h5>
              <p class="card-text price">
                <span v-if="relateditem.discount">
                  <del>MMK {{ relateditem.price }}</del>
                  MMK {{ calculateNewPrice(relateditem.price, relateditem.discount) }} ({{ relateditem.discount }} % off )
                </span>
                <span v-else>
                  MMK {{ relateditem.price }}
                </span>
              </p>
            <div class="d-flex justify-content-between align-items-center mb-2">
              <button @click="decrement(relateditem.id)" class="btn btn-link px-2 mr-2">
                <b-icon icon="dash" aria-hidden="true"></b-icon>
              </button>
              <div v-for="quantity in quantities" :key="quantity.id" v-show="relateditem.id == quantity.id">
                <b-form-input type="number" class="text-right reduced-opacity" min="0.00" :value="quantity.count">{{ quantity.count }}</b-form-input>
              </div>
              <button @click="increment(relateditem.id)" class="btn btn-link px-2 ml-2">
                <b-icon icon="plus" aria-hidden="true"></b-icon>
              </button>
            </div>
            <button class="btn btn-primary btn-add-to-cart" @click="create_cart_item(relateditem)">Add to cart</button>
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
  auth: 'guest',
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
      activeNavItem: '',
      amount: 0
    }
  },
  methods: {
    loggedIn(){
      this.$router.push('/login');
    },
    async logout(){
      await this.$auth.logout();
      this.$notify({
          title: 'Success',
          text: 'Logout successful',
        });
      this.$router.push('/')
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
    calculateNewPrice(originalPrice, discount) {
      const discountAmount = (originalPrice * discount) / 100;
      const newPrice = originalPrice - discountAmount;
      return newPrice; // Assuming you want to display the new price with 2 decimal places
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
    if(this.$auth.loggedIn)
    {
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
      if (this.$auth.user.user.role != "admin") {
        this.$axios.post(`getAmount?user_id=${this.$auth.user.user.id}`)
          .then(response => {
            this.amount = response.data.amount;
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
      }
    }
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

.index-container {
  background-image: url('../assets/backery_index_img.jpg');
  background-size: cover;
  background-position: center;
  background-attachment: fixed; /* Keep the background image fixed */
  height: 100vh;
  overflow-y: scroll; /* Allow vertical scrolling for content */
}
.container {
  padding-top: 20px;
}

.navbar-brand {
  font-size: 1.5rem;
  font-weight: bold;
}

.nav-tabs .nav-link {
  font-size: 1rem;
  padding: 0.5rem 1rem;
  color: #495057;
}
.nav-tabs {
  border-bottom: 1px solid rgba(6, 6, 6, 0.5);
  border-top-left-radius: 25px;
  
}

.nav-tabs .nav-link.active {
  background-color:  rgba(255, 255, 255, 0.7);
  color: black;
}

.nav-item button{
  border-top-left-radius: 25px;
}

.btn-link,.btn-link:hover{
  color: black;
}
.card-container {
  width: 100%; /* Expand to full width */
  margin: auto;
  padding-top: 150px;
}

.card {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  transition: transform 0.2s, box-shadow 0.2s;
  background-color: rgba(255, 255, 255, 0.5);
}

.card:hover {
  box-shadow: 0 8px 12px rgba(0, 0, 0, 0.15);
  transform: scale(1.05);
}

.card-img-top {
  object-fit: cover;
  height: 30vh;
}

.card-title {
  font-size: 1.25rem;
  font-weight: bold;
  margin-bottom: 0.5rem;
}

.description {
  height: 5em; /* Set a fixed height for the description */
  overflow: hidden;
}

.price {
  font-size: 1rem;
  margin-bottom: 1rem;
}

.btn-add-to-cart {
  width: 100%;
}

.btn-light {
  background-color: #f8f9fa;
  width: 2.5rem;
  height: 2.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
}

.btn-light:hover {
  background-color: #e9ecef;
}

.reduced-opacity {
  background-color: rgba(255, 255, 255, 0.5);
}
input[type=number]::-webkit-inner-spin-button,
  input[type=number]::-webkit-outer-spin-button {
    -webkit-appearance: none;
    margin: 0;
  }
</style>