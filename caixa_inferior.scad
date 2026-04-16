// ============================================================
//  Caixa Inferior - Conjunto Mecânico
//  Formato: Escudo/Gota (shield shape)
//  Peça impressa em 3D - rosa/pink
//
//  Medidas estimadas (ajuste com paquímetro):
//    - Largura total:         ~65 mm
//    - Profundidade total:    ~70 mm
//    - Altura total:          ~35 mm
//    - Espessura da parede:   ~3  mm
//    - Espessura do fundo:    ~3  mm
//    - Pino lateral:          diâm. ~6 mm, altura ~8 mm
//    - Encaixes laterais:     ~4 x 4 mm
// ============================================================

// --- Parâmetros (edite conforme medidas do paquímetro) ---
largura         = 65;   // mm - largura máxima da caixa
profundidade    = 70;   // mm - comprimento (frente-trás)
altura          = 35;   // mm - altura total
espessura_parede = 3;   // mm
espessura_fundo  = 3;   // mm

// Pino de alinhamento (canto superior)
pino_diametro   = 6;    // mm
pino_altura     = 8;    // mm
pino_offset_x   = -24; // posição X relativa ao centro
pino_offset_y   = 25;  // posição Y relativa ao centro

// Encaixes laterais (pequenas saliências para travas)
encaixe_w       = 6;    // largura do encaixe
encaixe_h       = 4;    // altura do encaixe
encaixe_d       = 4;    // profundidade (saliência)

$fn = 80;

// ============================================================
//  MÓDULO: Perfil 2D do escudo
//  Forma: retângulo na parte superior + ponta arredondada na base
// ============================================================
module perfil_escudo(w, d) {
    r_topo  = w * 0.12;   // arredondamento dos cantos superiores
    r_base  = w * 0.08;   // arredondamento da ponta inferior

    hull() {
        // Canto superior esquerdo
        translate([-w/2 + r_topo,  d/2 - r_topo])
            circle(r = r_topo);

        // Canto superior direito
        translate([ w/2 - r_topo,  d/2 - r_topo])
            circle(r = r_topo);

        // Ponta inferior (centro) - forma a gota/escudo
        translate([0, -d/2 + r_base])
            circle(r = r_base);

        // Alargamento lateral esquerdo
        translate([-w/2 + r_topo, 0])
            circle(r = r_topo);

        // Alargamento lateral direito
        translate([ w/2 - r_topo, 0])
            circle(r = r_topo);
    }
}

// ============================================================
//  MÓDULO: Caixa (externo - interno = paredes)
// ============================================================
module caixa_escudo() {
    difference() {

        // --- SÓLIDO EXTERNO ---
        union() {
            // Corpo principal extrudado
            linear_extrude(height = altura)
                perfil_escudo(largura, profundidade);

            // Pino de alinhamento (canto superior esquerdo)
            translate([pino_offset_x, pino_offset_y, altura])
                cylinder(h = pino_altura, d = pino_diametro);

            // Encaixe lateral esquerdo (trava para tampa)
            translate([-largura/2 - encaixe_d + espessura_parede,
                       -5,
                        altura * 0.55])
                cube([encaixe_d, encaixe_w, encaixe_h], center = true);

            // Encaixe lateral direito (trava para tampa)
            translate([ largura/2 - espessura_parede,
                       -5,
                        altura * 0.55])
                cube([encaixe_d, encaixe_w, encaixe_h], center = true);
        }

        // --- CAVIDADE INTERNA ---
        // Remove o interior mantendo paredes e fundo
        translate([0, 0, espessura_fundo])
            linear_extrude(height = altura + 1) // +1 para abrir o topo
                perfil_escudo(
                    largura  - 2 * espessura_parede,
                    profundidade - 2 * espessura_parede
                );
    }
}

// ============================================================
//  RENDER
// ============================================================
caixa_escudo();


// ============================================================
//  NOTAS
// ============================================================
// Ajuste os parâmetros no topo conforme as medidas reais
// obtidas com o paquímetro.
//
// Visualizar: F5  |  Renderizar: F6  |  Exportar STL: File > Export
//
// Dica: se a ponta inferior parecer muito afinada ou muito
// arredondada, ajuste o valor de "r_base" dentro do módulo
// perfil_escudo() ou altere "profundidade".
// ============================================================
