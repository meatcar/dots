

// Base16 Atelier Estuary light - simple terminal color setup
// Bram de Haan (http://atelierbram.github.io/syntax-highlighting/atelier-schemes/estuary)
static const char *colorname[] = {
	/* Normal colors */
	"#22221b", /*  0: Base 00 - Black   */
	"#ba6236", /*  1: Base 08 - Red     */
	"#7d9726", /*  2: Base 0B - Green   */
	"#a5980d", /*  3: Base 0A - Yellow  */
	"#36a166", /*  4: Base 0D - Blue    */
	"#5f9182", /*  5: Base 0E - Magenta */
	"#5b9d48", /*  6: Base 0C - Cyan    */
	"#929181", /*  7: Base 05 - White   */

	/* Bright colors */
	"#6c6b5a", /*  8: Base 03 - Bright Black */
	"#ba6236", /*  9: Base 08 - Red          */
	"#7d9726", /* 10: Base 0B - Green        */
	"#a5980d", /* 11: Base 0A - Yellow       */
	"#36a166", /* 12: Base 0D - Blue         */
	"#5f9182", /* 13: Base 0E - Magenta      */
	"#5b9d48", /* 14: Base 0C - Cyan         */
	"#f4f3ec", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#ae7313", /* 16: Base 09 */
	"#9d6c7c", /* 17: Base 0F */
	"#302f27", /* 18: Base 01 */
	"#5f5e4e", /* 19: Base 02 */
	"#878573", /* 20: Base 04 */
	"#e7e6df", /* 21: Base 06 */

	[255] = 0,

	[256] = "#5f5e4e", /* default fg: Base 02 */
	[257] = "#f4f3ec", /* default bg: Base 07 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;


