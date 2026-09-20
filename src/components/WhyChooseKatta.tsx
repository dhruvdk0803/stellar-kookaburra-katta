const benefits = [
  {
    number: '01',
    title: 'Verified quality',
    description: 'Established brands and dependable specifications.',
  },
  {
    number: '02',
    title: 'Project-ready range',
    description: 'From individual fittings to complete material schedules.',
  },
  {
    number: '03',
    title: 'Human guidance',
    description: 'Practical help when you need to compare or choose.',
  },
];

const WhyChooseKatta = () => {
  return (
    <section className="bg-[#17201d] px-4 py-20 text-white sm:px-6 sm:py-24">
      <div className="mx-auto max-w-7xl">
        <div className="grid gap-12 lg:grid-cols-[0.8fr_1.2fr] lg:gap-20">
          <div>
            <p className="text-[11px] font-semibold uppercase tracking-[0.24em] text-[#d8c6a2]">Why Katta</p>
            <h2 className="mt-4 max-w-md text-3xl font-normal leading-tight sm:text-4xl">A simpler way to source better materials.</h2>
          </div>
          <div className="grid gap-0 border-t border-white/[0.15] md:grid-cols-3 md:border-l md:border-t-0">
            {benefits.map((benefit) => (
              <div key={benefit.number} className="border-b border-white/[0.15] py-7 md:border-b-0 md:border-r md:px-7 md:py-2">
                <p className="text-xs text-[#d8c6a2]">{benefit.number}</p>
                <h3 className="mt-5 text-xl font-normal">{benefit.title}</h3>
                <p className="mt-3 text-sm leading-6 text-white/[0.58]">{benefit.description}</p>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
};

export default WhyChooseKatta;
