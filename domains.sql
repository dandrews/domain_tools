-- parent table
CREATE TABLE domains(name VARCHAR(255), tlds text[]);

-- child tables
CREATE TABLE domains_0_9 ( CHECK ( name ~ '^[0-9]') ) INHERITS (domains);
CREATE TABLE domains_a ( CHECK ( name ~ '^[a]') ) INHERITS (domains);
CREATE TABLE domains_b ( CHECK ( name ~ '^[b]') ) INHERITS (domains);
CREATE TABLE domains_c ( CHECK ( name ~ '^[c]') ) INHERITS (domains);
CREATE TABLE domains_d ( CHECK ( name ~ '^[d]') ) INHERITS (domains);
CREATE TABLE domains_e ( CHECK ( name ~ '^[e]') ) INHERITS (domains);
CREATE TABLE domains_f ( CHECK ( name ~ '^[f]') ) INHERITS (domains);
CREATE TABLE domains_g ( CHECK ( name ~ '^[g]') ) INHERITS (domains);
CREATE TABLE domains_h ( CHECK ( name ~ '^[h]') ) INHERITS (domains);
CREATE TABLE domains_i ( CHECK ( name ~ '^[i]') ) INHERITS (domains);
CREATE TABLE domains_j ( CHECK ( name ~ '^[j]') ) INHERITS (domains);
CREATE TABLE domains_k ( CHECK ( name ~ '^[k]') ) INHERITS (domains);
CREATE TABLE domains_l ( CHECK ( name ~ '^[l]') ) INHERITS (domains);
CREATE TABLE domains_m ( CHECK ( name ~ '^[m]') ) INHERITS (domains);
CREATE TABLE domains_n ( CHECK ( name ~ '^[n]') ) INHERITS (domains);
CREATE TABLE domains_o ( CHECK ( name ~ '^[o]') ) INHERITS (domains);
CREATE TABLE domains_p ( CHECK ( name ~ '^[p]') ) INHERITS (domains);
CREATE TABLE domains_q ( CHECK ( name ~ '^[q]') ) INHERITS (domains);
CREATE TABLE domains_r ( CHECK ( name ~ '^[r]') ) INHERITS (domains);
CREATE TABLE domains_s ( CHECK ( name ~ '^[s]') ) INHERITS (domains);
CREATE TABLE domains_t ( CHECK ( name ~ '^[t]') ) INHERITS (domains);
CREATE TABLE domains_u ( CHECK ( name ~ '^[u]') ) INHERITS (domains);
CREATE TABLE domains_v ( CHECK ( name ~ '^[v]') ) INHERITS (domains);
CREATE TABLE domains_w ( CHECK ( name ~ '^[w]') ) INHERITS (domains);
CREATE TABLE domains_x ( CHECK ( name ~ '^[x]') ) INHERITS (domains);
CREATE TABLE domains_y ( CHECK ( name ~ '^[y]') ) INHERITS (domains);
CREATE TABLE domains_z ( CHECK ( name ~ '^[z]') ) INHERITS (domains);

-- domains insert trigger function
CREATE OR REPLACE FUNCTION domains_insert_trigger()
RETURNS TRIGGER AS $$
BEGIN
    IF ( NEW.name ~ '^[0-9]' ) THEN
        INSERT INTO domains_0_9 VALUES (NEW.*);
    ELSIF ( NEW.name ~ '^[a]' ) THEN
        INSERT INTO domains_a VALUES (NEW.*);
    ELSIF ( NEW.name ~ '^[b]' ) THEN
        INSERT INTO domains_b VALUES (NEW.*);
    ELSIF ( NEW.name ~ '^[c]' ) THEN
        INSERT INTO domains_c VALUES (NEW.*);
    ELSIF ( NEW.name ~ '^[d]' ) THEN
        INSERT INTO domains_d VALUES (NEW.*);
    ELSIF ( NEW.name ~ '^[e]' ) THEN
        INSERT INTO domains_e VALUES (NEW.*);
    ELSIF ( NEW.name ~ '^[f]' ) THEN
        INSERT INTO domains_f VALUES (NEW.*);
    ELSIF ( NEW.name ~ '^[g]' ) THEN
        INSERT INTO domains_g VALUES (NEW.*);
    ELSIF ( NEW.name ~ '^[h]' ) THEN
        INSERT INTO domains_h VALUES (NEW.*);
    ELSIF ( NEW.name ~ '^[i]' ) THEN
        INSERT INTO domains_i VALUES (NEW.*);
    ELSIF ( NEW.name ~ '^[j]' ) THEN
        INSERT INTO domains_j VALUES (NEW.*);
    ELSIF ( NEW.name ~ '^[k]' ) THEN
        INSERT INTO domains_k VALUES (NEW.*);
    ELSIF ( NEW.name ~ '^[l]' ) THEN
        INSERT INTO domains_l VALUES (NEW.*);
    ELSIF ( NEW.name ~ '^[m]' ) THEN
        INSERT INTO domains_m VALUES (NEW.*);
    ELSIF ( NEW.name ~ '^[n]' ) THEN
        INSERT INTO domains_n VALUES (NEW.*);
    ELSIF ( NEW.name ~ '^[o]' ) THEN
        INSERT INTO domains_o VALUES (NEW.*);
    ELSIF ( NEW.name ~ '^[p]' ) THEN
        INSERT INTO domains_p VALUES (NEW.*);
    ELSIF ( NEW.name ~ '^[q]' ) THEN
        INSERT INTO domains_q VALUES (NEW.*);
    ELSIF ( NEW.name ~ '^[r]' ) THEN
        INSERT INTO domains_r VALUES (NEW.*);
    ELSIF ( NEW.name ~ '^[s]' ) THEN
        INSERT INTO domains_s VALUES (NEW.*);
    ELSIF ( NEW.name ~ '^[t]' ) THEN
        INSERT INTO domains_t VALUES (NEW.*);
    ELSIF ( NEW.name ~ '^[u]' ) THEN
        INSERT INTO domains_u VALUES (NEW.*);
    ELSIF ( NEW.name ~ '^[v]' ) THEN
        INSERT INTO domains_v VALUES (NEW.*);
    ELSIF ( NEW.name ~ '^[w]' ) THEN
        INSERT INTO domains_w VALUES (NEW.*);
    ELSIF ( NEW.name ~ '^[x]' ) THEN
        INSERT INTO domains_x VALUES (NEW.*);
    ELSIF ( NEW.name ~ '^[y]' ) THEN
        INSERT INTO domains_y VALUES (NEW.*);
    ELSIF ( NEW.name ~ '^[z]' ) THEN
        INSERT INTO domains_z VALUES (NEW.*);
    ELSE
        RAISE EXCEPTION 'Date out of range.  Fix the measurement_insert_trigger() function!';
    END IF;
    RETURN NULL;
END;
$$
LANGUAGE plpgsql;

-- trigger to call trigger function --
CREATE TRIGGER insert_domains_trigger
    BEFORE INSERT ON domains
    FOR EACH ROW EXECUTE PROCEDURE domains_insert_trigger();

RETURN;

-- child table indexes
CREATE INDEX domains_0_9_name ON domains_0_9 (name);
CREATE INDEX domains_a_name ON domains_a (name);
CREATE INDEX domains_b_name ON domains_b (name);
CREATE INDEX domains_c_name ON domains_c (name);
CREATE INDEX domains_d_name ON domains_d (name);
CREATE INDEX domains_e_name ON domains_e (name);
CREATE INDEX domains_f_name ON domains_f (name);
CREATE INDEX domains_g_name ON domains_g (name);
CREATE INDEX domains_h_name ON domains_h (name);
CREATE INDEX domains_i_name ON domains_i (name);
CREATE INDEX domains_j_name ON domains_j (name);
CREATE INDEX domains_k_name ON domains_k (name);
CREATE INDEX domains_l_name ON domains_l (name);
CREATE INDEX domains_m_name ON domains_m (name);
CREATE INDEX domains_n_name ON domains_n (name);
CREATE INDEX domains_o_name ON domains_o (name);
CREATE INDEX domains_p_name ON domains_p (name);
CREATE INDEX domains_q_name ON domains_q (name);
CREATE INDEX domains_r_name ON domains_r (name);
CREATE INDEX domains_s_name ON domains_s (name);
CREATE INDEX domains_t_name ON domains_t (name);
CREATE INDEX domains_u_name ON domains_u (name);
CREATE INDEX domains_v_name ON domains_v (name);
CREATE INDEX domains_w_name ON domains_w (name);
CREATE INDEX domains_x_name ON domains_x (name);
CREATE INDEX domains_y_name ON domains_y (name);
CREATE INDEX domains_z_name ON domains_z (name);
    
