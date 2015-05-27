#include "string.h"
#include <string.h>
#include <iostream>

//StrRef
StrRef::StrRef(String * s, int ix):ps(s),index(ix)
{
}

StrRef::operator char()
{
   return ps->get(index);
}

char StrRef::operator=(char c)
{
    ps->set(index, c);
    return c;
}

//StrMng
bool StrMng::zero()
{
    return ref_count == 0;
}

StrMng::StrMng(char * p)
{
    str = p;
}

char * StrMng::getStr()
{
    return str;
}

int StrMng::getRef()
{
    return ref_count;
}

void StrMng::addCount()
{
    ++ref_count;
}

void StrMng::subCount()
{
    --ref_count;
}

StrMng::~StrMng()
{
    delete str;
}

//String
void String::reset()
{
    if (mng){
        mng->subCount();
        if (mng->zero()){
            delete mng;
        }
        mng = nullptr;
    }
}

String::~String()
{
    reset();
}

String::String(const String & s):mng(s.mng)
{
    if (mng){
      mng->addCount();
    }
}

String & String::operator=(const String & s)
{
    if (this!=&s){
        reset();
        mng = s.mng;
        if (mng){
            mng->addCount();
        }
    }
}

String::String(char * cstr)
{
    char * p = new char[strlen(cstr) + 1];
    strcpy(p, cstr);
    mng = new StrMng(p);
    mng->addCount();
}

void String::set(int ix, char c)
{
    char * p = new char[strlen(mng->getStr()) + 1];
    strcpy(p, mng->getStr());
    p[ix] =c;
    reset();
    mng = new StrMng(p);
    mng->addCount();
}

char String::get(int ix)
{
    return mng->getStr()[ix];
}

void String::p()
{
    std::cout<<"ref: "<<mng->getRef()<<" str:"<<mng->getStr()<<std::endl;
}

StrRef String::operator[](int x)
{
  return StrRef(this, x);
}
