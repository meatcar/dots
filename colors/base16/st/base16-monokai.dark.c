

// Base16 Monokai dark - simple terminal color setup
// Wimer Hazenberg (http://www.monokai.nl)
static const char *colorname[] = {
	/* Normal colors */
	"#272822", /*  0: Base 00 - Black   */
	"#f92672", /*  1: Base 08 - Red     */
	"#a6e22e", /*  2: Base 0B - Green   */
	"#f4bf75", /*  3: Base 0A - Yellow  */
	"#66d9ef", /*  4: Base 0D - Blue    */
	"#ae81ff", /*  5: Base 0E - Magenta */
	"#a1efe4", /*  6: Base 0C - Cyan    */
	"#f8f8f2", /*  7: Base 05 - White   */

	/* Bright colors */
	"#75715e", /*  8: Base 03 - Bright Black */
	"#f92672", /*  9: Base 08 - Red          */
	"#a6e22e", /* 10: Base 0B - Green        */
	"#f4bf75", /* 11: Base 0A - Yellow       */
	"#66d9ef", /* 12: Base 0D - Blue         */
	"#ae81ff", /* 13: Base 0E - Magenta      */
	"#a1efe4", /* 14: Base 0C - Cyan         */
	"#f9f8f5", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#fd971f", /* 16: Base 09 */
	"#cc6633", /* 17: Base 0F */
	"#383830", /* 18: Base 01 */
	"#49483e", /* 19: Base 02 */
	"#a59f85", /* 20: Base 04 */
	"#f5f4f1", /* 21: Base 06 */

	[255] = 0,

	[256] = "#f8f8f2", /* default fg: Base 05 */
	[257] = "#272822", /* default bg: Base 00 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;

