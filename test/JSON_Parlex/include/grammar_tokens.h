
			 #ifndef FLEX_GRAMMAR_H_
			 
			 #define FLEX_GRAMMAR_H_
			 
			 #define TOKEN_NUM 19
#define NTERM_LEN 8
#define TERM_LEN  11
#define S OBJECT

#define is_terminal(token) ((uint8_t)((token & 0x40000000) >> 30))
#define token_value(token) ((uint32_t)(token & 0xBFFFFFFF))
#define gr_term_key(token) (token_value(token) - NTERM_LEN)
#define gr_nterm_key(token)(token_value(token))
#define gr_term_token(key) ((gr_token)(0xBFFFFFFF | (key + NTERM_LEN)))
#define gr_nterm_token(key) ((gr_token)key)

typedef enum gr_token {
  OBJECT = 0, MEMBERS, PAIR, VALUE, STRING, CHARS, ARRAY, ELEMENTS,
  LBRACE = 0x40000008, RBRACE, COMMA, COLON, NUMBER, BOOL, QUOTES, CHAR, LSQUARE, RSQUARE, TERM
} gr_token;

#endif
