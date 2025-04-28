
#ifndef __GDT_H
#define __GDT_H

#include "types.h"

	class GDT // global descriptor table
	{
		
		public:
			class SD // segment descriptor
			{
			private:
				uint16_t limit_lo;
				uint16_t base_lo;
				uint8_t base_hi;
				uint8_t type;
				uint8_t flags_limit_hi;
				uint8_t base_vhi;
				
			public:
				SD(uint32_t base,uint32_t limit,uint8_t type);
				uint32_t Base();
				uint32_t Limit();
				
			} __attribute__((packed));
			
		SD nullSegmentSelector;
		SD unusedSegmentSelector;
		SD codeSegmentSelector;
		SD dataSegmentSelector;
		
	public:
	
	
		GDT();
		~GDT();
		
		uint16_t CodeSegmentSelector();
		uint16_t DataSegmentSelector();
		
	};



#endif 