

// Base16 Ocean dark - simple terminal color setup
// Chris Kempson (http://chriskempson.com)
static const char *colorname[] = {
	/* Normal colors */
	"#2b303b", /*  0: Base 00 - Black   */
	"#bf616a", /*  1: Base 08 - Red     */
	"#a3be8c", /*  2: Base 0B - Green   */
	"#ebcb8b", /*  3: Base 0A - Yellow  */
	"#8fa1b3", /*  4: Base 0D - Blue    */
	"#b48ead", /*  5: Base 0E - Magenta */
	"#96b5b4", /*  6: Base 0C - Cyan    */
	"#c0c5ce", /*  7: Base 05 - White   */

	/* Bright colors */
	"#65737e", /*  8: Base 03 - Bright Black */
	"#bf616a", /*  9: Base 08 - Red          */
	"#a3be8c", /* 10: Base 0B - Green        */
	"#ebcb8b", /* 11: Base 0A - Yellow       */
	"#8fa1b3", /* 12: Base 0D - Blue         */
	"#b48ead", /* 13: Base 0E - Magenta      */
	"#96b5b4", /* 14: Base 0C - Cyan         */
	"#eff1f5", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#d08770", /* 16: Base 09 */
	"#ab7967", /* 17: Base 0F */
	"#343d46", /* 18: Base 01 */
	"#4f5b66", /* 19: Base 02 */
	"#a7adba", /* 20: Base 04 */
	"#dfe1e8", /* 21: Base 06 */

	[255] = 0,

	[256] = "#c0c5ce", /* default fg: Base 05 */
	[257] = "#2b303b", /* default bg: Base 00 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;

