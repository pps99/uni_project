<template>
  <div class="container">
    <div class="dropdown ml-2">
      <button class="btn btn-secondary dropdown-toggle" type="button" data-toggle="dropdown" aria-expanded="false">
        <span class="notification-badge">{{ cart_items.length }}</span>
        <span class="sr-only">Notifications</span>
        <b-icon icon="cart-plus-fill" aria-hidden="true"></b-icon> Cart
      </button>
      <div class="dropdown-menu" v-on:click.stop v-show="cart_items.length > 0" style="width: 300px; opacity: 0.9;">
        <a class="dropdown-item" v-for="cart_item in cart_items" :key="cart_item.id">
          <div class="clearfix">
            <div class="float-left">
              <span>
                {{ cart_item.quantity }}
              </span>
              <span>
                {{ cart_item.cake_name }}
              </span>
              <span>
                {{ cart_item.total }}
              </span>
            </div>
            <button id="delete-icon" class="float-right" @click="delete_an_item(cart_item.id)">
                <b-icon icon="trash" aria-hidden="true" style="color: red;"></b-icon>
            </button>
          </div>
          <hr class="hr hr-blurry" />
        </a>
        <div class="clearfix">
          <NuxtLink :to="{ name: 'sub_pages-order_view', params: {cartitems: cart_items}}" class="float-right mt-2 btn btn-outline-info">Order</NuxtLink>
        </div>
      </div>
    </div >
  </div>
</template>

<script>
export default {
  data(){
    return {
      cart_items: [],
      indexToRemove: ''
    }
  },
  methods: {
    get_all_card_items(){
      this.$axios.get(`/cart_items/all`)
        .then(response => {
          this.cart_items = response.data.cart_items
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
    delete_an_item(id){
      this.$axios.delete(`/cart_items/${id}`)
        .then(response => {
          this.indexToRemove = this.cart_items.findIndex(item => item.id === id);
          this.cart_items.splice(this.indexToRemove, 1);
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
  },

  mounted() {
    this.get_all_card_items()
  },
  
};
</script>
<style>

  .dropdown {
    position: relative;
    display: inline-block;
  }

  .dropdown-menu {
    display: none;
    position: absolute;
    max-height: 150px; /* Set the maximum height for scrollable content */
    overflow-y: auto; /* Enable vertical scrolling */
    z-index: 1;
  }
  .dropdown-item:hover, .dropdown-item:focus{
    background: none;
  }
  .notification-indicator {
    position: relative;
    display: inline-block;
  }

  .notification-badge {
    position: absolute;
    top: -5px;
    right: -5px;
    background-color: red;
    color: white;
    font-size: 12px;
    padding: 2px 6px;
    border-radius: 50%;
  }

  #delete-icon{
    background: none;
    border: none;
  }
</style>