<template>
  <div class="container pt-0">
    <div class="dropdown ml-2">
      <button class="btn btn-secondary dropdown-toggle" type="button" data-toggle="dropdown" aria-expanded="false">
        <span class="notification-badge">{{ cart_items.length }}</span>
        <span class="sr-only">Notifications</span>
        <b-icon icon="cart-plus-fill" aria-hidden="true"></b-icon> Cart
      </button>
      <div class="dropdown-menu dropdown-menu-right" style="width: 50vh;" v-on:click.stop v-show="cart_items.length > 0">
        <a class="dropdown-item" v-for="cart_item in cart_items" :key="cart_item.id">
          <div class="clearfix">
            <div class="float-left">
              <div class="item-details">
                <span class="item-name">{{ cart_item.cake_name }}</span>
                <span class="item-quantity">{{ cart_item.quantity }}</span>
                <span class="item-price">{{ cart_item.unit_price * cart_item.quantity }}</span>
              </div>
            </div>
            <button id="delete-icon" class="float-right btn-delete" @click="delete_an_item(cart_item)">
              <b-icon icon="trash" aria-hidden="true" class="delete-icon"></b-icon>
            </button>
          </div>
          <hr class="hr hr-blurry" />
        </a>
        <div class="clearfix">
          <button
            v-if="!shouldDisableLink"
            class="float-right mt-2 btn btn-info btn-order"
            @click="confirm"
          >
            Order
          </button>
          <button v-else class="float-right mt-2 btn btn-info btn-order" disabled>
            Order
          </button>
        </div>
      </div>
    </div>
    <div class="modal" id="alertModal">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Alert</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            Please log in first to place an order.
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  props: {
    cart_items: [],
    shouldDisableLink: '',
    amount: 0
  },
  data(){
    return {
      indexToRemove: '',
    }
  },
  methods: {
    delete_an_item(itemToDelete){
      const index = this.cart_items.indexOf(itemToDelete);
      if (index !== -1) {
        this.cart_items.splice(index, 1);
      }
    },
    confirm(){
      if(this.$auth.loggedIn){
        this.$router.push({ name: 'sub_pages-order_view', params: { amount: this.amount }});
      }else{
        // Show the alert modal
        const alertModal = document.getElementById('alertModal');
        $(alertModal).modal('show');
      }
    }
  },
  mounted() {
  }
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
  max-height: 150px;
  overflow-y: auto;
  z-index: 1;
  width: 300px; /* Set a fixed width */
  opacity: 0.9;
  border: none; /* Remove default dropdown border */
  box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
}

.dropdown-item:hover,
.dropdown-item:focus {
  background: none;
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

.item-details {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.item-name {
  flex-grow: 1;
  margin-right: 0.5rem;
}

.item-quantity,
.item-price {
  width: 40px; /* Adjust the width as needed */
  text-align: center;
}

.btn-delete {
  background: none;
  border: none;
  cursor: pointer;
}

.btn-order {
  width: 100%;
}

.item-quantity-price {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
</style>