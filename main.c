#ifdef _MSC_VER
#define _CRT_SECURE_NO_WARNINGS
#endif // _MSC_VER


#include <stdio.h>
#include <stdlib.h>
#include "bmp.h"

BFHeader bf;

int main(int argc, char* argv[]) {

	FILE* fp;
	char arg[] = "C:\\Users\\moraes\\Documents\\1.bmp";
	int larguraTotal = 0;
	int bytesPerRow = 0;
	int x, y;
	int byteAtual = 0;
	int cont = 0;

	fp = fopen(arg, "rb");
	if (!fp) {
		printf("Deu pala ao abrir a imagem!\n");
		return(0);
	}

	FillHeader(&bf, fp);

	//printf("%c%c\n", bf.signature[0], bf.signature[1]);
	//printf("%X\n", bf.imageSize);
	//printf("%hX\n", bf.reserved1);
	//printf("%hX\n", bf.reserved2);
	//printf("%X\n", bf.pixelDataOffset);
	//printf("%X\n", bf.BIHeader.bitsPerPixel);
	//printf("%X\n", bf.BIHeader.imageWidth);

	if (bf.BIHeader.bitsPerPixel != 1) {
		printf("Só Funciona com imagens monocromáticas\n");
		fclose(fp);
		return(0);
	};

	larguraTotal = bf.BIHeader.bitsPerPixel * bf.BIHeader.imageWidth;
	bytesPerRow = celling(larguraTotal, 32) * 4;

	fseek(fp, bf.pixelDataOffset, SEEK_SET);

	for (y = 0; y < bf.BIHeader.imageHeigth; y++) {
		for (x = 0; x < bytesPerRow; x++); {
			fread(&byteAtual, 1, 1, fp);
			for (cont = 7; cont >= 0; cont--) {
				printf("%d\n", checkBits(&byteAtual, cont));
			}
		}
	};

	printf("largura total : %d\n", larguraTotal);
	printf("bytes por linha : %d\n", bytesPerRow);

	return(0);
}