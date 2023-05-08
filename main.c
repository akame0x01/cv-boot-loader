#ifdef _MSC_VER
#define _CRT_SECURE_NO_WARNINGS
#endif // _MSC_VER


#include <stdio.h>
#include <stdlib.h>
#include "bmp.h"

BFHeader bf;
//char** repBMP; Representaçao do BMP na memória

int main(int argc, char* argv[]) {

	FILE* fp;
	char arg[] = "C:\\Users\\moraes\\Desktop\\2.bmp";
	int larguraTotal = 0;
	int bytesPerRow;
	int y, x;
	int byteAtual = 0;
	int cont = 0;
	int qntBits = 0;
	int qntBitsSeguidos = 0;
	unsigned char temp = 0;  
	unsigned char bitAtual = 1; //O bit definido no começo é branco

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
		return(0);
	};

	larguraTotal = bf.BIHeader.bitsPerPixel * bf.BIHeader.imageWidth;
	bytesPerRow = celling(larguraTotal, 32) * 4;
	//repBMP = (unsigned char**)malloc(bf.BIHeader.imageHeigth * sizeof(unsigned char*)); malloc é um metodo que guarda um espaço na memoria reservado em bytes 

	fseek(fp, bf.pixelDataOffset, SEEK_SET);

	//for (y = 0; y < bf.BIHeader.imageHeigth; y++) {
	//	repBMP[y] = (unsigned char*)malloc(larguraTotal * sizeof(char) + 1);
	//	memset(repBMP[y], '\0', (sizeof(char) * larguraTotal + 1));
	//	qntBits = 0;
	//	for (x = 0; x < bytesPerRow; x++) {

	//		fread(&byteAtual, 1, 1, fp);

	//		for (cont = 7; cont >= 0; cont--) {
	//			if (qntBits < larguraTotal) {
	//				if (checkBits(&byteAtual, cont) == 1) repBMP[y][qntBits] = '+';
	//				else repBMP[y][qntBits] = '-';
	//			}
	//			qntBits++;
	//			//e quando essa caralhada de for termina,a  representaçao na imagem na memória estará completa,onde 1 = "+" e 0 = "-"
	//		}
	//	}
	//}

	//for (y = bf.BIHeader.imageHeigth - 1; y >= 0; y--) {
	//	printf("%s\n", repBMP[y]);
	//};


	for (y = 0; y < bf.BIHeader.imageHeigth; y++) {

		/*repBMP[y] = (unsigned char*)malloc(larguraTotal * sizeof(char) + 1);
		memset(repBMP[y], '\0', (sizeof(char) * larguraTotal + 1));*/

		qntBits = 0; // aqui é zerada as duas variaveis pq acabou 1 linha
		qntBitsSeguidos = 0; 

		for (x = 0; x < bytesPerRow; x++) {

			fread(&byteAtual, 1, 1, fp);

			for (cont = 7; cont >= 0; cont--) {
				if (qntBits < larguraTotal) {
					temp = checkBits(&byteAtual, cont);
					if (temp == bitAtual) qntBitsSeguidos++;
					else {
						printf("%d, ", qntBitsSeguidos);
						qntBitsSeguidos = 1;
						bitAtual = temp;
					}
					if (qntBitsSeguidos >= 255) {
						return 0;
					}
				}
				qntBits++;
			
			}
		}
		printf("%d, ", qntBitsSeguidos);
	}

	return(0);
}