// plugins/websocket.js
import ActionCable from 'actioncable';

const cable = ActionCable.createConsumer('ws://localhost:8080/cable'); // Update with your WebSocket server URL

export default (context, inject) => {
  inject('cable', cable);
};
