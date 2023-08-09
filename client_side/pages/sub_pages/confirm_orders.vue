<template>
  <div v-if='nothingtoshow' class="d-flex align-items-center justify-content-center" style="height: 100vh;">
    <button class="btn btn-link" type="button"  @click="goback()">Nothing To Show Go Back TO Main Page</button>
  </div>
  <div v-else class="accordion" id="accordionExample">
    <div v-for="groupeditem in groupeditems" :key="groupeditem.id">
      <div class="card d-flex align-items-center justify-content-center mt-4" style="border: none;">
        <div class="card-header rounded-pill" id="headingOne">
          <h2 class="mb-0">
            <span>
              Order_No: 
            </span>
            <span>Status: {{ groupeditem[0].status }}</span>
            <span>
              <button class="btn btn-link" type="button" data-toggle="collapse" :data-target="'#collapse-' + groupeditem[0].id" aria-expanded="true" :aria-controls="'collapse-' + groupeditem[0].id" @click="openModalWithData(groupeditem)">
                Order Detail
              </button>
            </span>
          </h2>
        </div>

        <div :id="'collapse-' + groupeditem[0].id" class="collapse" aria-labelledby="headingOne" data-parent="#accordionExample">
          <div class="card-body" style="width: 18rem;">
            <table class="table">
              <thead>
              <tr>
                <th scope="col" style="text-align: center;">Name</th>
                <th scope="col" style="text-align: center;">Quantity</th>
                <th scope="col" style="text-align: center;">Price</th>
              </tr>
              </thead>
              <tbody v-for="relateditems in dataArray" :key="relateditems.id" class="m-4">
                <tr>
                <td style="text-align: center;">{{ relateditems.cake_name }}</td>
                <td style="text-align: center;">{{ relateditems.quantity }}</td>
                <td style="text-align: center;">{{ relateditems.total }}   </td> 
                </tr>
              </tbody>
              </table>
              <div class="clear-fix">
                <button class="float-right" @click="acceptOrder(groupeditem)">Accept Order</button>
                <button class="float-left">Cancel Order</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
</template>
<script>
export default{
  data() {
    return {
      groupeditems: [],
      dataArray: [],
      showContent: false,
      index: 0,
      nothingtoshow: false,
    }
  },
  methods: {
    fetch_related_items() {
      this.$axios.get(`/user_details`)
        .then(response => {
          this.$router.push('#')
          this.groupeditems = response.data.grouped_user_details
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
    openModalWithData(dataArray) {
      this.dataArray = dataArray
      this.showContent = !this.showContent
    },
    acceptOrder(groupeditem){
      this.$axios.post(`/user_details/accept?user_id=${groupeditem[0].user_id}&create_at=${groupeditem[0].created_at}`)
        .then(response => {
          this.groupeditems = response.data.grouped_user_details
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
    goback(){
      this.$router.push('/')
    }
        
  },
  mounted() {
    this.fetch_related_items()
    if(this.groupeditems.length == 0)
    {
      this.nothingtoshow = true
    }
  }
}

</script>
<style scoped>
</style>