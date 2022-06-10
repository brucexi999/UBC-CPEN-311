#include <stdlib.h>
#include <stdio.h>


#define low_address (volatile unsigned long *) 0x000a100
#define high_address (volatile unsigned long *) 0x000a104
#define pre_count ( unsigned long long *) 0x0001010
#define post_count ( unsigned long long *) 0x0001020
//#define transient_lower_count ( unsigned long *) 0x0001010
//#define transient_upper_count ( unsigned long *) 0x0001020
#define result ( unsigned long long *) 0x0001000
extern inline unsigned long long hw_counter();

int main() {

	
    measure (1000, 2000); 
    
	return 0;
}

inline unsigned long long hw_counter() {
	//argument x is either *pre_count or *count, it
	//consider the corner case
	unsigned long long x; 
	unsigned long transient_lower_count; 
	unsigned long transient_upper_count;
	//unsigned long long count; 
	
	transient_lower_count = (*low_address); //Store the value of our first read for the lower half.
	transient_upper_count = (*high_address);
	if (transient_lower_count > 0xffffff00) { 
	/*First, read the lower half, see if the value is greater than ffffff00, 
	i.e. close to the corner case*/
	/*Second, read the lower half again, if it is smaller than ffffff00, 
	e.g., 00000008, then there must be a corner case happened, we need to 
	subtract 1 from our upper half reading.*/
		 
		if (*low_address < 0xffffff00) {
			(transient_upper_count) = (transient_upper_count - 0x00000001); //Subtract upper reading by 1. 
			x = (transient_upper_count); 
			x = (x << 32) + (transient_lower_count); //Combine the two halves. 
		} 
		
		else {
			x = (transient_upper_count);
			x = (x << 32) + transient_lower_count;
		}
	} 
	
	else {
		//(*count) = (*transient_lower_count);
		//(*count) = ((*count) >> 32) | (*transient_upper_count);
		//(*count) = ((*count) << 32);
	x = transient_upper_count;
	x = (x << 32) + transient_lower_count;
	}
	
	
	return x;
}

int __attribute__((noinline)) measure(int min_i, int max_i) {
	//unsigned long long pre_count; 
	//unsigned long long post_count; 
    register int i, j;
    j = 0;
    *pre_count = hw_counter();
    for (i = min_i; i < max_i; ++i) {
      j += i * i;
    }
    *post_count = hw_counter();
	*result = (*post_count - *pre_count);  
    return j;
}