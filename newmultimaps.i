%module newmultimaps

%include "std_vector.i"
%include "std_string.i"

%{

  #define SWIG_FILE_WITH_INIT

  #include "mmap/mmap.hpp"
  #include "mmap/mmap_gen.hpp"

  #include "mmap/random.hpp"
  #include "mmap/benchmark.hpp"
  #include "mmap/crt_tree.hpp"
  #include "mmap/mpz_shoup.hpp"

%}


/////////////////////////////////////////////////


namespace mmap {

struct parameters;
class public_parameters;
class encoding;

struct parameters
{
        unsigned lambda;
        unsigned kappa;
        unsigned n;
        unsigned eta;
        unsigned etaq;
        unsigned rho;
        unsigned alpha;
        unsigned xi;
        unsigned beta;
        unsigned nu;
        unsigned ne;
        unsigned rhof;
        std::string pathname;

        unsigned etap;
        unsigned nbp;
        unsigned delta;

        parameters() {}

        bool init(unsigned lambda, unsigned kappa);
        void create(unsigned n, unsigned rho, unsigned etap);

        bool load_mpz(mpz_class &, const char *filename);
        bool load_mpz_array(mpz_class *, unsigned, const char *filename);
        bool save_mpz(mpz_class &, const char *filename);
        bool save_mpz_array(mpz_class *, unsigned, const char *filename);
};

class public_parameters
{
protected:
        mpz_class *p;
        mpz_class *g;
        mpz_class z;
        mpz_class x0;
        mpz_class *CRT_coeffs_p;
        mpz_class *Qp; // Q mod p[i]
        mpz_class *h;
        mpz_class *Np; // N mod p_i
        crt_tree  crt;
        mpz_class **zki; // z^-k [kappa+1][n]
        bool params_loaded;

public:
        mpz_class *x;
        mpz_class **pi;
        mpz_class y;
        mpz_class x0p;
        mpz_class *yp;
        mpz_class N;
        mpz_class p_zt;
        parameters params;

        public_parameters(unsigned lambda, unsigned kappa);
        ~public_parameters();

        bool load();

        void samp(mpz_class &rop, unsigned level);
        encoding enc(const encoding &c, unsigned level);
        void enc(mpz_class &rop, unsigned level);
        void rerand(mpz_class &rop, unsigned level);
        mpz_class ext(encoding &, unsigned nu = 0);

protected:
        void encrypt(mpz_class &, mpz_class *values, unsigned level = 0);

        std::vector<unsigned> decrypt(const mpz_class &, unsigned level);
        std::vector<unsigned> decrypt(const encoding &);
        std::vector<unsigned> noises(const mpz_class &, unsigned level);
        std::vector<unsigned> noises(const encoding &);
};

class encoding
{
public:
        public_parameters *pp;
        mpz_class value;
        unsigned level;

        encoding() {};
        encoding(const public_parameters &, unsigned level = 0);
        encoding(const encoding &c) : pp(c.pp), value(c.value), level(c.level) {};
        encoding(public_parameters *pp, const mpz_class &value, unsigned level): pp(pp), value(value), level(level) {};

        void samp(const public_parameters &, unsigned level);
        void rerand();

        encoding &operator*=(const encoding &);
        encoding &operator=(const encoding &);
};

}


////////////////////////////////////////////


namespace std {

  %template(StringVector) std::vector<std::string>;
}

namespace mmap {

%exception generate{
   try {
      $action
   } catch( std::logic_error ) {
      PyErr_SetString(PyExc_RuntimeError, "test");
      SWIG_fail;
   }
}

class public_parameters_generate : public public_parameters
{
private:
        mpz_class z_invert;
        mpz_class z_mkappa;
        mpz_class *zi;
        mpz_class *ziinv; // z^(-1) mod p_i
        mpz_class x0inv;
        mpz_class x0inv_shoup;
        std::vector<fplll::ZZ_mat<mpz_t>> Mat;
        crt_tree  crtN;

public:
        public_parameters_generate(unsigned lambda, unsigned kappa, unsigned n, unsigned rho, unsigned etap);
        ~public_parameters_generate();
        void generate();
        void save();

private:
        void generate_p(unsigned i);
        void generate_g(unsigned i);
        void generate_z();
        void generate_CRT_coeffs(unsigned i);
        void generate_x();
        void generate_pi(unsigned level);
        void generate_y();
        void generate_yp();
        void generate_N();
        void generate_h();
        void generate_p_zt();
        void generate_p_zt_coeff(unsigned i);

        void multisamp(mpz_class **results, mpz_class ***values, unsigned m, unsigned level);
};

}
