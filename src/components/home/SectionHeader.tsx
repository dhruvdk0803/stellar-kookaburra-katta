import { Link } from 'react-router-dom';
import { textLink } from './styles';

interface SectionHeaderProps {
  id: string;
  title: string;
  linkTo?: string;
  linkLabel?: string;
}

const SectionHeader = ({ id, title, linkTo, linkLabel }: SectionHeaderProps) => (
  <div className="mb-8 flex items-center justify-between gap-6 sm:mb-10">
    <h2 id={id} className="min-w-0 text-balance text-2xl font-medium sm:text-[2rem] sm:leading-tight">{title}</h2>
    {linkTo && linkLabel && <Link to={linkTo} className={`${textLink} shrink-0`}>{linkLabel}</Link>}
  </div>
);

export default SectionHeader;
