class String;
class StrRef
{
    public:                        // LHS = RHS
        operator char();      // when RHS
        char operator=(char c);    // when LHS
        friend String;
    private:
        StrRef(String * s,int ix);         //Only String can create it
        String * ps;
        int index;
};

class StrMng
{
    public:
        char * getStr();
        int getRef();
        void addCount();
        void subCount();
        bool zero();
        StrMng(char * p);
        StrMng(const StrMng &) =delete;
        StrMng & operator=(const StrMng &) =delete;
        ~StrMng();
    private:
        int ref_count;
        char * str;
};

class String
{
    public:
        String(char * cstr);
        String(const String & s);
        String & operator=(const String & s);
        void set(int ix, char c);
        char get(int ix);
        void p();
        void reset();
        StrRef operator[](int x);
        ~String();
    private:
        StrMng * mng;
};
