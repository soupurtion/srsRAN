sudo gnome-terminal -- bash -c "sudo ./srsepc/src/srsepc"
sudo gnome-terminal -- bash -c "./srsenb/src/srsenb --rf.device_name=zmq --rf.device_args=\"fail_on_disconnect=true,tx_port=tcp://*:2000,rx_port=tcp://localhost:2001,id=enb,base_srate=23.04e6\""
sudo gnome-terminal -- bash -c "sudo ./srsue/src/srsue --rf.device_name=zmq --rf.device_args=\"tx_port=tcp://*:2001,rx_port=tcp://localhost:2000,id=ue,base_srate=23.04e6\" --gw.netns=ue1"
