#pragma once
#include <stdio.h>

struct BitmapInfoHeader {
	unsigned int headerSize; //Precisa ser 40! Aqui diz o tamanho deste header! offset 0E
	unsigned int imageWidth; //offset 12h
	unsigned int imageHeigth; //offset 16h
	unsigned short planes; //offset 1Ah. Precisa ser 1
	short bitsPerPixel; //"Color Depth". Valores t�picos s�o 1, 4, 8, 16, 24 e 32
	//Eu s� quero as imagens monocrom�ticas. Ent�o esse valor precisa ser 1
	//Offset 1Ch
	unsigned int compression; //Compress�o usada. Offset 1Eh
	/* Valores poss�veis:
	Value	Identified by	Compression method	Comments
		0	BI_RGB	none	Most common
		1	BI_RLE8	RLE 8 - bit / pixel	Can be used only with 8 - bit / pixel bitmaps
		2	BI_RLE4	RLE 4 - bit / pixel	Can be used only with 4 - bit / pixel bitmaps
		3	BI_BITFIELDS	OS22XBITMAPHEADER : Huffman 1D	BITMAPV2INFOHEADER : RGB bit field masks,
		BITMAPV3INFOHEADER + : RGBA
		4	BI_JPEG	OS22XBITMAPHEADER : RLE - 24	BITMAPV4INFOHEADER + : JPEG image for printing[14]
		5	BI_PNG		BITMAPV4INFOHEADER + : PNG image for printing[14]
		6	BI_ALPHABITFIELDS	RGBA bit field masks	only Windows CE 5.0 with.NET 4.0 or later
		11	BI_CMYK	none	only Windows Metafile CMYK[4]
		12	BI_CMYKRLE8	RLE - 8	only Windows Metafile CMYK
		13	BI_CMYKRLE4	RLE - 4	only Windows Metafile CMYK*/
	unsigned int imageRawSize; //Pode ser zero; offset 22h
	unsigned int horizontalResolution; //Pixel por metro; offset 26h
	unsigned int verticalResolution; //Pixel por metro; offset 2Ah
	unsigned int colorPallete; //N�mero de cores na palheta. A maioria s� bota 0. Offset 2Eh
	unsigned int importantColors; //Geralmente ignorado. Ent�o 0 por padr�o. Offset 32h

};

struct BitmapFileHeader {
	unsigned char signature[2]; //offset 00
	unsigned int imageSize; //offset 02
	short reserved1; //offset 06
	short reserved2; //offset 08
	unsigned int pixelDataOffset; //offset 0A
	struct BitmapInfoHeader BIHeader;
};

typedef struct BitmapFileHeader BFHeader;
typedef struct BitmapInfoHeader BIHeader;

void FillHeader(BFHeader* bf, FILE* fp);
int celling(int x, int y);
int checkBits(unsigned char* ch, int posicao);