<template>
  <div class="confirmorder-container">
    <div v-if="nothingtoshow" class="d-flex align-items-center justify-content-center" style="height: 100vh;">
      <button class="btn btn-info" style="color: black; background-color: white;" type="button" @click="goback()">Nothing To Show Go Back To Main Page</button>
    </div>
    <div v-else class="accordion" id="accordionExample">
      <div v-for="order in pending_orders_with_details" :key="order.id">
        <div class="card d-flex align-items-center justify-content-center mt-4" style="border: none; background-color: transparent;">
          <div class="card-header confirmorder-card reduced-opacity" :ref="'confirmordercard-' + order['order'].id"   id="headingOne">
            <h5 class="mb-0">
              <span>
                Order_No: {{ order['order'].id }} <!-- Display actual order number here -->
              </span>
              <span class="ml-3">Option: {{ order['order'].option }}</span>
              <span class="ml-3">Total: {{ order['order'].total }} MMK</span>
              <span class="ml-2">
                <button class="btn btn-light" type="button" data-toggle="collapse" :data-target="'#collapse-' + order['order'].id" aria-expanded="true" :aria-controls="'collapse-' + order['order'].id" @click="openModalWithData(order['order'])">
                  Order Detail
                </button>
              </span>
            </h5>
            <div :id="'collapse-' + order['order'].id" class="collapse" aria-labelledby="headingOne" data-parent="#accordionExample">
            <div class="card-body radius" style="background-color: #e2e6ea;" >
              <h6>Customer Name: &nbsp;&nbsp;&nbsp;{{ order['order'].name }}</h6>
              <h6>Phone: &nbsp;&nbsp;&nbsp;{{ order['order'].phone }}</h6>
              <h6>Address: &nbsp;&nbsp;&nbsp;{{ order['order'].address }}</h6>
              <table class="table">
                <thead>
                  <tr>
                    <th scope="col" style="text-align: center;">Name</th>
                    <th scope="col" style="text-align: center;">Quantity</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="order_detail in order['order_details']" :key="order_detail.id" class="m-4">
                    <td style="text-align: center;">{{ order_detail.cake_name }}</td>
                    <td style="text-align: center;">{{ order_detail.quantity }}</td>
                  </tr>
                </tbody>
              </table>
              <div class="clear-fix pb-4">
                <button class="float-right btn btn-accept-order" @click="acceptOrder(order)">Accept Order</button>
                <button class="float-left btn btn-cancel-order" href="javascript:void(0)" data-toggle="modal" :data-target="'#staticBackdrop-'+order['order'].id">Cancel Order</button>
              </div>

            <!-- Modal -->
            <div class="modal fade" :id="'staticBackdrop-'+order['order'].id" data-backdrop="static" data-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
              <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content reduced-modal-opacity" style="border-radius: 25px;">
                  <div class="modal-header">
                    <h5 class="modal-title" id="staticBackdropLabel">Add A Description Why You Cancel Order</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" @click="close">
                      <span aria-hidden="true">&times;</span>
                    </button>
                  </div>
                  <div class="modal-body">
                    <form action="" @submit.prevent="cancelOrder(order)">
                      <div class="form-group">
                        <label for="description">Description:</label>
                        <textarea class="form-control reduced-modal-opacity " id="description" v-model="description"></textarea>
                      </div>
                      <div class="d-flex justify-content-between">
                        <button type="button" class="btn btn-secondary rounded-pill" data-dismiss="modal" @click="close">Close</button>
                        <button class="btn btn-primary rounded-pill btn btn-danger">cancelOrder</button>
                      </div>
                    </form>
                  </div>
                </div>
              </div>
            </div>
            </div>
          </div>
          </div>


        </div>
      </div>
      <div class="d-flex align-items-center justify-content-center mt-3">
        <button class="btn reduced-opacity mt-3 w-10 m-auto" type="button" @click="goback()">Main Page</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      pending_orders_with_details: [],
      nothingtoshow: false,
      description: '',
    }
  },
  methods: {
    fetch_related_items() {
      this.$axios.get(`/orders`)
        .then(response => {
          this.pending_orders_with_details = response.data.pending_orders_with_details;
          if (this.pending_orders_with_details.length === 0) {
            this.nothingtoshow = true;
          }
        })
        .catch(error => {
          this.$notify({
            title: 'Fail',
            text: 'Something went wrong. Please try again',
            type: 'error'
          });
          this.errors = error.response.data.error;
          this.errorMessage = true;
        });
    },
    openModalWithData(dataArray) {
      this.dataArray = dataArray;
      this.showContent = !this.showContent;
      if (this.showContent){
        this.$refs['confirmordercard-' + dataArray.id][0].classList.remove('confirmorder-card');
        this.$refs['confirmordercard-' + dataArray.id][0].classList.add('confirmorder-card-border');
      }else{
        this.$refs['confirmordercard-' + dataArray.id][0].classList.add('confirmorder-card');
        this.$refs['confirmordercard-' + dataArray.id][0].classList.remove('confirmorder-card-border'); 
      }
    },
    acceptOrder(order) {
      console.log(order['order'])
      this.$axios.post(`/orders/accept?order_id=${order['order'].id}`)
        .then(response => {
          if( this.pending_orders_with_details.length === 0)
          {
            this.nothingtoshow = true
          }
          window.location.reload();
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
    cancelOrder(order) {
      this.$axios.post(`/orders/cancel?order_id=${order['order'].id}&description=${this.description}`)
        .then(response => {
          if( this.pending_orders_with_details.length === 0)
          {
            this.nothingtoshow = true
          }
          window.location.reload();
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
    goback() {
      this.$router.push('/');
    },
    close(){
        this.description = ''
        this.errorMessage = false
    }
  },
  mounted() {
    this.fetch_related_items();
  },
};
</script>

<style scoped>
  .confirmorder-container{
    background-image: url('~/assets/backery_index_img.jpg');
    background-size: cover;
    background-position: center;
    background-attachment: fixed; /* Keep the background image fixed */
    height: 100vh;
    overflow-y: scroll; /* Allow vertical scrolling for content */
  }

  .reduced-opacity {
    background-color: rgba(255, 255, 255, 0.5);
  }

  .reduced-modal-opacity {
    background-color: rgba(255, 255, 255, 0.8);
  }

  .confirmorder-card{
    border-top-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }

  .confirmorder-card-border{
   border-radius: 25px;
  }
  
  .radius{
    border-bottom-left-radius: 25px;
    border-bottom-right-radius: 25px;
  }

  .btn.btn-light:focus {
    box-shadow: none; /* Remove the default focus box-shadow */
    outline: none; /* Remove the default focus outline */
  }

  .btn-accept-order {
    background-color: #00ffea9a; /* Orange */
    color: white;
    border-color: #00ffea9a;
  }

  .btn-cancel-order {
    background-color: #dc3545; /* Red */
    color: white;
    border-color: #dc3545;
  }
</style>
