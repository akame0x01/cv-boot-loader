#include "bmp.h"


int celling(int x, int y) {
	// if(x % y > 0) {
	// 	return((x/y + 1));
	// }

	// return(x/y);

	//operador ternário é basicamente um if,ele recebe uma condiçao e executa uma instruçao depende se a condiçao for f ou v
	return(x % y ? x / y + 1 : x / y);
}

void FillHeader(BFHeader* bf, FILE* fp) {
	//BitmapFileHeader
	fread(&bf->signature, 2, 1, fp);
	fread(&bf->imageSize, 4, 1, fp);
	fread(&bf->reserved1, 2, 1, fp);
	fread(&bf->reserved2, 2, 1, fp);
	fread(&bf->pixelDataOffset, 4, 1, fp);

	//BitmapInfoHeader
	fread(&bf->BIHeader.headerSize, 4, 1, fp);
	fread(&bf->BIHeader.imageWidth, 4, 1, fp);
	fread(&bf->BIHeader.imageHeigth, 4, 1, fp);
	fread(&bf->BIHeader.planes, 2, 1, fp);
	fread(&bf->BIHeader.bitsPerPixel, 2, 1, fp);
	fread(&bf->BIHeader.compression, 4, 1, fp);
	fread(&bf->BIHeader.imageRawSize, 4, 1, fp);
	fread(&bf->BIHeader.horizontalResolution, 4, 1, fp);
	fread(&bf->BIHeader.verticalResolution, 4, 1, fp);
	fread(&bf->BIHeader.colorPallete, 4, 1, fp);
	fread(&bf->BIHeader.importantColors, 4, 1, fp);

}

int checkBits(unsigned char* ch, int posicao) {
	__asm {
		mov ebx, posicao
		mov eax, [ebp + 0x08]
		mov eax, [eax]
		bt eax, ebx
		jc ret1
		xor eax, eax
		jmp fim
		ret1 :
		xor eax, eax
			inc eax
			fim :
	};
}