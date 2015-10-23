#include <iostream>
#include "booksim_interface.cpp"

int nodes = 16;
int vcs = 2;

void check_credits()
{
	for(int i = 0; i < nodes; i++)
		for(int j = 0; j < vcs; j++)
		{
			if(receive_credit(i,j))
				cout << "Node " << i << " VC " << j <<  " returned a credit" << endl; 
		}
}

int main()
{
	
	connectSocket();
/*
	
	queueFlit(0,1,0,3,1,0);
	inject();
	check_credits();
	nextCycle(1);
	
	queueFlit(0,2,0,3,0,0);
	inject();
	check_credits();
	nextCycle(1);
	
	queueFlit(0,3,0,3,0,0);
	inject();
	check_credits();
	nextCycle(1);
	
	queueFlit(0,4,0,3,0,1);
	inject();
	check_credits();
*/	nextCycle(1);


	
	queueFlit(1,0,2,4,0,1,0);
	inject();
	check_credits();
	nextCycle(1);
	
	queueFlit(1,1,2,4,0,0,0);
	inject();
	check_credits();
	nextCycle(1);
	
	queueFlit(1,2,2,4,0,0,0);
	inject();
	check_credits();
	nextCycle(1);
	
	queueFlit(1,3,2,4,0,0,0);
	inject();
	check_credits();
	nextCycle(1);
	
	queueFlit(1,4,2,4,0,0,0);
	inject();
	check_credits();
	nextCycle(1);

	queueFlit(1,5,2,4,0,0,0);
	inject();
	check_credits();
	nextCycle(1);

	queueFlit(1,6,2,4,0,0,0);
	inject();
	check_credits();
	nextCycle(1);
	
	queueFlit(1,7,2,4,0,0,0);
	inject();
	check_credits();
	nextCycle(1);
	
//	queueFlit(1,8,2,4,0,0,0);
//	inject();
//	check_credits();
//	nextCycle(1);

	queueFlit(1,9,2,4,0,0,0);
	inject();
	check_credits();
	nextCycle(1);
	
	queueFlit(1,10,2,4,0,0,0);
	inject();
	check_credits();
	nextCycle(1);
	
	queueFlit(1,11,2,4,0,0,1);
	inject();
	check_credits();
	nextCycle(1);

	for(int i = 0;i < 50; i++){
		//if(i < 10)
		//	propagate_stall(4,1);
		//else
		//	propagate_stall(4,0);
		int rec_id = 99;
		int rec_vc = 99;
		int rec = eject(&rec_id, &rec_vc);
		std::cout << "received " << rec_id << std::endl;
		check_credits();
		nextCycle(1);
	}

	int rec_id = 99;
	int rec_vc = 99;
	
	//send a credit back
	send_credit(4,0,1);
	eject(&rec_id, &rec_vc);
	std::cout << " received " << rec_id << std::endl;
	nextCycle(1);
	
	send_credit(4,0,1);
	eject(&rec_id, &rec_vc);
	std::cout << " received " << rec_id << std::endl;
	nextCycle(1);

	send_credit(4,0,1);
	eject(&rec_id, &rec_vc);
	std::cout << " received " << rec_id << std::endl;
	nextCycle(1);

	send_credit(4,0,1);
	eject(&rec_id, &rec_vc);
	std::cout << " received " << rec_id << std::endl;
	nextCycle(1);

	send_credit(4,0,1);
	eject(&rec_id, &rec_vc);
	std::cout << " received " << rec_id << std::endl;
	nextCycle(1);

	eject(&rec_id, &rec_vc);
	std::cout << " received " << rec_id << std::endl;
	nextCycle(1);


	eject(&rec_id, &rec_vc);
	std::cout << " received " << rec_id << std::endl;
	nextCycle(1);



	eject(&rec_id, &rec_vc);
	std::cout << " received " << rec_id << std::endl;
	nextCycle(1);



	eject(&rec_id, &rec_vc);
	std::cout << " received " << rec_id << std::endl;
	nextCycle(1);



	eject(&rec_id, &rec_vc);
	std::cout << " received " << rec_id << std::endl;
	nextCycle(1);



	eject(&rec_id, &rec_vc);
	std::cout << " received " << rec_id << std::endl;
	nextCycle(1);



	eject(&rec_id, &rec_vc);
	std::cout << " received " << rec_id << std::endl;
	nextCycle(1);



	eject(&rec_id, &rec_vc);
	std::cout << " received " << rec_id << std::endl;
	nextCycle(1);



	eject(&rec_id, &rec_vc);
	std::cout << " received " << rec_id << std::endl;
	nextCycle(1);



	eject(&rec_id, &rec_vc);
	std::cout << " received " << rec_id << std::endl;
	nextCycle(1);



	eject(&rec_id, &rec_vc);
	std::cout << " received " << rec_id << std::endl;
	nextCycle(1);



	eject(&rec_id, &rec_vc);
	std::cout << " received " << rec_id << std::endl;
	nextCycle(1);



	eject(&rec_id, &rec_vc);
	std::cout << " received " << rec_id << std::endl;
	nextCycle(1);


	nextCycle(1);
	nextCycle(1);
	nextCycle(1);
	nextCycle(1);


	exitSocket();

	return 0;

}
